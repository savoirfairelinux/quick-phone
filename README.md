quick-phone - Simple touch intercom
=========

quick-phone is a QML application for a simple touch screen intercom using QtQuick.

## Build Instructions

    git clone https://github.com/savoirfairelinux/quick-phone.git
    cd quick-phone
    qmake && make

This will build an executable file called `quickPhone`

## Customize for your needs

* Replace the logo located in img/logo_white_text.png and img/reception_contact_picture.png with your own.
* Replace users from userList.json with your own.
* Populate pictures/ folder with your users pictures in png format. Files must be named after the sip extension of the user.
* Populate ts_7990_config.ini with your own sip and audio configuration.
* Optionnaly you can replace intro_video.mp4 with your own. Video will be played in an infinite loop on the home page background.
