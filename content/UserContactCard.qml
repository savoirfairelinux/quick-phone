import QtQuick 2.1
import Process 1.0
import "../app.js" as JS

Item {
  id: contactCard

  property alias name: usernameText.text
  property alias ext: userphoneText.text
  property alias jobTitle: jobTitleText.text
  property alias team: teamText.text
  property alias pictureLocation: contactPicture.source

  anchors.fill: parent

  MouseArea {
    //MouseArea will fill the zone behind the user card
    anchors.fill: parent

    // If user clic outside the user card, go back to list view and hangup if needed
    onClicked: {
      process.terminate();
      JS.deleteContactCard(contactCard);
    }
  }

  Rectangle {
    width: parent.width * 4 / 5
    height: parent.height * 2 / 3
    anchors.centerIn: parent

    color: "#000000"
    border.color: "#2d3435"
    border.width: 5
    radius: 15

    MouseArea {
      // overide onClic event for clic on the user card
      anchors.fill: parent
    }

    // Close Button
    Rectangle {
      width: parent.width * 1 / 20
      height: parent.height * 1 / 20

      anchors.right: parent.right
      anchors.top: parent.top
      anchors.rightMargin: 10
      anchors.topMargin: 20

      color: "Black"

      Text {
        font.pixelSize: 42
        anchors.centerIn: parent
        color: "white"
        text: "X"
      }

      MouseArea {
        anchors.fill: parent
        onClicked: {
          // Hang up and go back to list view
          process.terminate();
          JS.deleteContactCard(contactCard);
        }
      }
    }

    // Contact Picture holder
    Rectangle {
      id: pictureHolder

      width: parent.height * 2 / 5
      height: parent.height * 2 / 5

      anchors.verticalCenter: parent.verticalCenter
      x: parent.width * 1/10

      color: "white"

      Image {
        id: contactPicture
        property int errorCount: 0
        anchors.centerIn: parent
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: "../img/default_contact_picture.png"

        onStatusChanged: {
          // if we cannot load contact picture, use default image
          if (contactPicture.status == Image.Error) {
            errorCount += 1;
            if (errorCount != 0) {
              contactPicture.source = ""
              contactPicture.source = "../img/default_contact_picture.png";
            }
          }
        }
      }
    }

    // Contact name
    Text {
      id: usernameText
      color: "white"
      font.pixelSize: 32
      text: "Name"
      anchors.top: pictureHolder.top
      anchors.left: pictureHolder.right
      anchors.leftMargin: 20
    }

    // Contact job title
    Text {
      id: jobTitleText
      color: "white"
      font.pixelSize: 20
      text: "Title"
      anchors.top: usernameText.bottom
      anchors.left: pictureHolder.right
      anchors.leftMargin: 20
    }

    // Contact team
    Text {
      id: teamText
      color: "white"
      font.pixelSize: 20
      text: "team"
      anchors.top: jobTitleText.bottom
      anchors.left: pictureHolder.right
      anchors.leftMargin: 20
    }

    // Contact sip extension
    Text {
      id: userphoneText
      text: "ext"
      visible: false
    }

    // Call button
    Rectangle {
      id: callButton

      width: parent.width * 1 / 8
      height: parent.width * 1 / 8
      color: "transparent"

      x: contactCard.width * 2 / 5
      y: contactCard.height * 2 / 5

      Image {
        anchors.fill: parent
        source: "../img/phone_call.png"
      }
      MouseArea {
        id: callButtonClicEvent
        anchors.fill: parent

        Process {
            id: process
            onReadyRead: console.info(readAll());
            onReadyReadStandardError: console.info(readAllStandardError());

            onFinished: {
              // Go back to home page
              console.info('Contact has finished the call');
              process.terminate();
              JS.deleteContactCard(contactCard);
              userListModelView.reset();
              stackView.pop();
            }
        }
        // call the user using pjsip
        onClicked: {
          console.info("Calling sip extension:", ext);
          if (ext === "reception") {
            process.start("./caller.py", [ "-c", "ts_7990_config.ini", "-r"]);
          } else {
            process.start("./caller.py", [ "-c", "ts_7990_config.ini", "-e", ext ]);
          }

          callButton.visible = false
          callButtonClicEvent.enabled = false
          hangupButton.visible = true
          hangupButtonClicEvent.enabled = true
        }
      }
    }

    // Hangup Button
    Rectangle {
      id: hangupButton

      visible: false

      width: parent.width * 1 / 8
      height: parent.width * 1 / 8
      color: "transparent"

      x: callButton.x + 2 * callButton.width
      y: contactCard.height * 2 / 5

      Image {
        anchors.fill: parent
        source: "../img/phone_hangup.png"
      }
      MouseArea {
        id: hangupButtonClicEvent
        anchors.fill: parent
        enabled: false

        onClicked: {
          // Hang up and go back to list view
          console.info('User has finished the call');
          process.terminate();
          JS.deleteContactCard(contactCard);
          userListModelView.reset();
          stackView.pop();
        }
      }
    }
  }
}
