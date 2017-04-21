#!/usr/bin/env python
# $Id: registration.py 2171 2008-07-24 09:01:33Z bennylp $
#
# SIP account and registration sample. In this sample, the program
# will block to wait until registration is complete
#
# Copyright (C) 2003-2008 Benny Prijono <benny@prijono.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
import sys
import pjsua as pj
import threading
import signal
import time
import ConfigParser
import argparse

current_call = None
quit_application = False
player_ringing = None

sip_extension = None
sip_password = None
sip_domain = None
sip_reception_extension = None
sip_peer = None

audio_micro_id = None
audio_speaker_id = None

default_config_file = "config.ini"

def _get_config(path):

    global sip_extension
    global sip_password
    global sip_domain
    global sip_reception_extension
    global audio_micro_id
    global audio_speaker_id

    config = ConfigParser.ConfigParser()
    config.read(path)

    # get sip config
    sip_extension = config.get('sip', 'extension')
    sip_password = config.get('sip', 'password')
    sip_domain = config.get('sip', 'domain')
    sip_reception_extension = config.get('sip', 'reception_extension')

    # get audio config
    audio_micro_id = config.get('audio', 'micro_id')
    audio_speaker_id = config.get('audio', 'speaker_id')

def _args_parser(args):

    global sip_peer
    global sip_reception_extension

    if hasattr(args, "config") and args.config:
        config_file_path = args.config
    else:
        print("missing configuration file")
        lib.destroy()
        sys.exit(1)

    try:
        _get_config(config_file_path)
    except Exception:
        print("configuration incorrect")
        lib.destroy()
        sys.exit(1)

    if hasattr(args, "reception") and args.reception:
        sip_peer = sip_reception_extension
    elif hasattr(args, "extension") and args.extension:
        sip_peer = args.extension
    else:
        print("missing parameters")


def log_cb(level, str, len):
    print str,

def _sig_handler(signum, frame):

    global quit_application

    if current_call:
        current_call.hangup()
        quit_application = True

class MyAccountCallback(pj.AccountCallback):
    sem = None

    def __init__(self, account):
        pj.AccountCallback.__init__(self, account)

    def wait(self):
        self.sem = threading.Semaphore(0)
        self.sem.acquire()

    def on_reg_state(self):
        if self.sem:
            if self.account.info().reg_status >= 200:
                self.sem.release()

# Callback to receive events from Call
class MyCallCallback(pj.CallCallback):

    def __init__(self, call=None):

        pj.CallCallback.__init__(self, call)

    # Notification when call state has changed
    def on_state(self):

        global current_call
        global cv
        global quit_application
        global player_ringing

        if self.call.info().state == pj.CallState.DISCONNECTED and current_call:
            # we get disconnected
            current_call = None
            quit_application = True

        elif (self.call.info().state == pj.CallState.CONFIRMED and
                not player_ringing):
            # stop the ringing tone
            lib.conf_disconnect(lib.player_get_slot(player_ringing), 0)

    # Notification when call's media state has changed.
    def on_media_state(self):

        if self.call.info().media_state == pj.MediaState.ACTIVE:
            # Connect the call to sound device
            call_slot = self.call.info().conf_slot
            pj.Lib.instance().conf_connect(call_slot, 0)
            pj.Lib.instance().conf_connect(0, call_slot)
            print "Media is now active"
        else:
            print "Media is inactive"

lib = pj.Lib()
signal.signal(signal.SIGINT, _sig_handler)
signal.signal(signal.SIGTERM, _sig_handler)

parser = argparse.ArgumentParser()
parser.add_argument('-c', '--config', help='use a configuration file')
parser.add_argument('-e', '--extension', help='call a sip extension')
parser.add_argument('-r', '--reception', help='contact the reception', action='store_true')
_args_parser(parser.parse_args())

try:

    lib.init(log_cfg = pj.LogConfig(level=1, callback=log_cb))
    lib.create_transport(pj.TransportType.UDP, pj.TransportConfig(5080))
    # set built-in pieso speaker to output and usb micro to input
    lib.set_snd_dev(int(audio_micro_id), int(audio_speaker_id))
    lib.start()

    acc = lib.create_account(
            pj.AccountConfig(sip_domain, sip_extension, sip_password))

    acc_cb = MyAccountCallback(acc)
    acc.set_callback(acc_cb)
    acc_cb.wait()

    print "\n"
    print "Registration complete, status=", acc.info().reg_status, \
          "(" + acc.info().reg_reason + ")"

    if sip_peer:
        # play ringing tone until the call is confirmed
        player_ringing = lib.create_player("ringing.wav", loop=True)
        lib.conf_connect(lib.player_get_slot(player_ringing), 0)

        current_call = acc.make_call("sip:"+sip_peer+"@"+sip_domain, cb=MyCallCallback())

        while True:
            # a main loop checking every second if we shall quit or not
            time.sleep(1)
            if quit_application:
                break
    else:
        print "please provide an extension to call"


except pj.Error, e:
    print "Exception: " + str(e)

lib.destroy()
