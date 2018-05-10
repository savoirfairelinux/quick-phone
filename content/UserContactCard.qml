import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 2.0
import Process 1.0

Item {
  id: contactCard

  signal closeContactCard

  property string name
  property real ext
  property string jobTitle
  property string team
  property string pictureLocation

  anchors.fill: parent

  signal componentLoaded(string name, real ext, string jobTitle, string team, string pictureLocation)

  onComponentLoaded: {
    contactCard.name = name;
    contactCard.ext = ext;
    contactCard.jobTitle = jobTitle;
    contactCard.team = team;
    contactCard.pictureLocation = pictureLocation;
  }

  Process {
      id: process
      onReadyRead: console.info(readAll());
      onReadyReadStandardError: console.info(readAllStandardError());

      onFinished: {
        // Go back to home page
        console.info('Contact has finished the call');
        process.terminate();
        contactCard.remove();
        userListModelView.reset();
        headerBar.visible = false;
        stackView.pop();
      }
  }

  MouseArea {
    //MouseArea will fill the zone behind the user card
    anchors.fill: parent

    // If user clic outside the user card and no call in progress,
    // go back to list view.
    onClicked: {
      if (sliderButton.state === "red") {
        contactCard.remove();
      }
    }
  }

  Rectangle {
    id: card

    property real widthRatio: contactCard.width * 2 / 3
    property real heightRatio: contactCard.height * 2 / 3

    color: "#000000"
    border.color: "#2d3435"
    border.width: 5
    radius: 15

    MouseArea {
      // overide onClic event for clic on the user card
      anchors.fill: parent
      onClicked: {
        iddleTimer.restart();
      }
    }

    // Contact Picture holder
    Rectangle {
      id: pictureHolder

      width: parent.height * 2 / 5
      height: parent.height * 2 / 5

      y: parent.width * 1/10
      x: parent.width * 1/10

      color: "white"

      Image {
        id: contactPicture
        property int errorCount: 0
        anchors.centerIn: parent
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: pictureLocation ? pictureLocation : "../img/default_contact_picture.png"

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
      text: name ? name : "Name"
      anchors.top: pictureHolder.top
      anchors.left: pictureHolder.right
      anchors.leftMargin: 20
      anchors.right: callImage.right
      anchors.rightMargin: 20
      wrapMode: Text.WordWrap
    }

    // Contact job title
    Text {
      id: jobTitleText
      color: "white"
      font.pixelSize: 20
      text: jobTitle ? jobTitle : "Title"
      anchors.top: usernameText.bottom
      anchors.left: pictureHolder.right
      anchors.leftMargin: 20
      anchors.right: callImage.right
      anchors.rightMargin: 20
      wrapMode: Text.WordWrap
    }

    // Contact team
    Text {
      id: teamText
      color: "white"
      font.pixelSize: 20
      text: team ? team : "Team"
      anchors.top: jobTitleText.bottom
      anchors.left: pictureHolder.right
      anchors.leftMargin: 20
      anchors.right: callImage.right
      anchors.rightMargin: 20
      wrapMode: Text.WordWrap
    }

    // Contact sip extension
    Text {
      id: userphoneText
      text: ext ? ext : "ext"
      visible: false
    }

    // Call button
    Slider {
      id: sliderButton

      property string imgSource: "../img/phone_call.png"
      property string sliderText: "#1233 >>>"

      anchors.top: pictureHolder.bottom
      anchors.topMargin: 20
      anchors.bottom: card.bottom
      anchors.bottomMargin: 20
      anchors.horizontalCenter: parent.horizontalCenter
      width: parent.width * 2 / 3

      state: "green"

      states: [
        State {
          name: "green"
          PropertyChanges { target: sliderButton; imgSource: "../img/phone_call.png"}
          PropertyChanges { target: sliderButton; sliderText: "Slide to call"}
        },
        State {
          name: "red"
          PropertyChanges { target: sliderButton; imgSource: "../img/phone_hangup.png"}
          PropertyChanges { target: sliderButton; sliderText: "Slide to hangup"}
        }
      ]

      value: 0
      updateValueWhileDragging : false

      onValueChanged: {
        // In 'no call' state
        if (sliderButton.state === "green") {
          if (sliderButton.value < 1) {
            sliderButton.value = 0;
            return;
          }

          sliderButton.state = "red";

          console.info("Calling sip extension:", ext);
          if (ext === "reception") {
            process.start("./caller.py", [ "-c", "ts_7990_config.ini", "-r"]);
          } else {
            process.start("./caller.py", [ "-c", "ts_7990_config.ini", "-e", ext ]);
          }
        }

        // In 'call' state
        if (sliderButton.state === "red") {
          if (sliderButton.value > 0) {
            sliderButton.value = 1;
            return;
          }

          // Hang up and go back to list view
          console.info('User has finished the call');
          sliderButton.state = "green";
          process.terminate();
          contactCard.remove();
          userListModelView.reset();
          headerBar.visible = false;
          stackView.pop();
        }
      }

      style: SliderStyle {
        groove: Rectangle {
          implicitWidth: sliderButton.width
          implicitHeight: sliderButton.height
          color: "grey"
          radius: 180

          Text {
            anchors.centerIn: parent
            color: "Black"
            font.pixelSize: 20
            text: sliderButton.sliderText
          }
        }
        handle: Rectangle {
          anchors.centerIn: parent
          color: "transparent"
          implicitWidth: sliderButton.height
          implicitHeight: sliderButton.height
          Image {
            id: callImage
            anchors.fill: parent
            source: sliderButton.imgSource
          }
        }
      }
    }
  }

  ParallelAnimation {
      id: onCreateAnimation
      running: true
      NumberAnimation { target: card; property: "width" ; duration: 200 ;
                        from: 0; to: card.widthRatio}
      NumberAnimation { target: card; property: "height"; duration: 200 ;
                        from: 0; to: card.heightRatio}
      NumberAnimation { target: card; property: "x"; duration: 200 ;
                        from: contactCard.width  / 2; to: (contactCard.width  - card.widthRatio)  / 2}
      NumberAnimation { target: card; property: "y"; duration: 200 ;
                        from: contactCard.height / 2; to: (contactCard.height - card.heightRatio) / 2}
      NumberAnimation { target: usernameText; property: "font.pixelSize"; duration: 200 ;
                        from: 0; to: 32}
      NumberAnimation { target: jobTitleText; property: "font.pixelSize"; duration: 200 ;
                        from: 0; to: 20}
      NumberAnimation { target: teamText; property: "font.pixelSize"; duration: 200 ;
                        from: 0; to: 20}
  }

  function remove() {
      onDeleteAnimation.running = true;
  }

  ParallelAnimation {
      id: onDeleteAnimation
      running: false
      NumberAnimation { target: card; property: "width" ; duration: 200 ;
                        from: card.widthRatio; to: 0}
      NumberAnimation { target: card; property: "height"; duration: 200 ;
                        from: card.heightRatio; to: 0}
      NumberAnimation { target: card; property: "x"; duration: 200 ;
                        from: (contactCard.width  - card.widthRatio)  / 2; to: contactCard.width  / 2}
      NumberAnimation { target: card; property: "y"; duration: 200 ;
                        from: (contactCard.height - card.heightRatio) / 2; to: contactCard.height / 2}

      NumberAnimation { target: usernameText; property: "font.pixelSize"; duration: 200 ;
                        from: 32; to: 0}
      NumberAnimation { target: jobTitleText; property: "font.pixelSize"; duration: 200 ;
                        from: 20; to: 0}
      NumberAnimation { target: teamText; property: "font.pixelSize"; duration: 200 ;
                        from: 20; to: 0}

      onRunningChanged: {
        if(running == false ) {
          closeContactCard();
        }
      }
  }

  Timer {
    id: iddleTimer

    interval: 15000
    running: true
    repeat: true

    onTriggered: {
      if (sliderButton.state === "red") {
        iddleTimer.restart();
        return;
      }

      console.info("App has been iddle for" + iddleTimer.interval / 1000 + "seconds")
      contactCard.remove();
      userListModelView.reset();
      headerBar.visible = false;
      stackView.pop();
    }
  }
}
