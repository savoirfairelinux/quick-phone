import QtQuick 2.7
import Process 1.0

Item {
    id: contactUser

    property bool selected
    onSelectedChanged: {
      if (!selected) {
        contactUser.state = "None";
      }
    }
    width: parent.width
    height: 88

    property string name_
    property real ext_
    property string jobTitle_
    property string team_
    property string pictureLocation_

    signal clicked
    signal pressed

    state: "None"

    Rectangle {
      anchors.fill: parent
      color: "#11ffffff"
      visible: selected
    }

    states: [
      State {
        name: "None"
      },
      State {
        name: "Selected"
      },
      State {
        name: "Calling"
      }
    ]

    transitions: [
      Transition {
        from: "None"; to: "Selected"
        SequentialAnimation {
          ParallelAnimation {
            NumberAnimation {target: contactUser; property: "height"; to: 200; duration: 200}
            NumberAnimation {target: username; property: "x"; to: 180; duration: 200}
          }
          ParallelAnimation {
            PropertyAction {target: jobTitle; property: "visible"; value: true}
            PropertyAction {target: team; property: "visible"; value: true}
            PropertyAction {target: contactPicture; property: "visible"; value: true}
          }
        }
      },
      Transition {
        from: "Selected"; to: "None"
        SequentialAnimation {
          ParallelAnimation {
            PropertyAction {target: jobTitle; property: "visible"; value: false}
            PropertyAction {target: team; property: "visible"; value: false}
            PropertyAction {target: contactPicture; property: "visible"; value: false}
          }
          ParallelAnimation {
            NumberAnimation {target: contactUser; property: "height"; to: 88; duration: 200}
            NumberAnimation {target: username; property: "x"; to: 30; duration: 200}
          }
        }
      },
      Transition {
        from: "Selected"; to: "Calling"
        SequentialAnimation {
          PropertyAction {target: selectItemArea; property: "enabled"; value: false}
          PropertyAction {target: userListModelView; property: "interactive"; value: false}
          ParallelAnimation {
            NumberAnimation {target: contactUser; property: "height"; to: userListModelView.height; duration: 200}
            NumberAnimation {target: userListModelView; property: "contentY"; to: (userListModelView.currentIndex) * 88; duration: 200}
            NumberAnimation {target: contactPicture; property: "x"; to: 80; duration: 200}
            NumberAnimation {target: username; property: "x"; to: 230; duration: 200}
          }
        }
      },
      Transition {
        from: "Calling"; to: "None"
        SequentialAnimation {
          ParallelAnimation {
            PropertyAction {target: jobTitle; property: "visible"; value: false}
            PropertyAction {target: team; property: "visible"; value: false}
            PropertyAction {target: contactPicture; property: "visible"; value: false}
          }
          ParallelAnimation {
            NumberAnimation {target: contactPicture; property: "x"; to: 30; duration: 200}
            NumberAnimation {target: contactUser; property: "height"; to: 88; duration: 200}
            NumberAnimation {target: username; property: "x"; to: 30; duration: 200}
          }
          PropertyAction {target: contactUser; property: "selected"; value: false}
          PropertyAction {target: userListModelView; property: "interactive"; value: true}
            PropertyAction {target: selectItemArea; property: "enabled"; value: true}
        }
      }
    ]

    Text {
      id: username
      color: "white"
      font.pixelSize: 32
      text: name_ ? name_ : "Name"
      anchors.verticalCenter: parent.verticalCenter
      x: 30
      wrapMode: Text.WordWrap
    }

    Text {
      id: jobTitle

      visible: false
      color: "white"
      font.pixelSize: 20
      text: jobTitle_ ? jobTitle_ : "Title"
      anchors.top: username.bottom
      anchors.left: username.left
      wrapMode: Text.WordWrap
    }

    Text {
      id: team

      visible: false
      color: "white"
      font.pixelSize: 20
      text: team_ ? team_ : "Team"
      anchors.top: jobTitle.bottom
      anchors.left: jobTitle.left
      wrapMode: Text.WordWrap
    }


    Image {
      id: contactPicture
      visible: false

      anchors.verticalCenter: parent.verticalCenter
      x: 30
      width: 120
      height: 160
      fillMode: Image.PreserveAspectFit
      source: pictureLocation_ ? pictureLocation_ : "../img/default_contact_picture.png"
      property int errorCount: 0
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

    MouseArea {
      id: selectItemArea
      anchors.fill: parent
      onClicked: contactUser.clicked();
      onPressed: contactUser.pressed();
    }

    Rectangle {
      id: callArea
      anchors.top: parent.top
      anchors.right: parent.right
      width: parent.width / 5
      height: parent.height
      color: callMouseArea.pressed ? "#33ffffff" : "#22ffffff"
      visible: contactUser.state === "Selected"

      Text {
        anchors.centerIn: parent
        text: "Call"
        color: "white"
        font.pixelSize: 32
      }
      MouseArea {
        id: callMouseArea
        anchors.fill: parent
        onClicked: {
          contactUser.state = "Calling"
          console.info("Calling sip extension:", ext);
          process.start("./caller.py", [ "-c", "./assets/config.ini", "-e", ext ]);
        }
      }
    }

    Rectangle {
      id: hangupArea
      anchors.top: parent.top
      anchors.right: parent.right
      width: parent.width / 5
      height: parent.height
      color: hangupMouseArea.pressed ? "#33ffffff" : "#22ffffff"
      visible: contactUser.state === "Calling"

      Text {
        anchors.centerIn: parent
        text: "Hangup"
        color: "white"
        font.pixelSize: 32
      }
      MouseArea {
        id: hangupMouseArea
        anchors.fill: parent
        onClicked: {
          contactUser.state = "None";
          process.terminate();
        }
      }
    }

    Text {
        id: userphoneText
        visible: false
        color: "white"
        font.pixelSize: 32
        text: ext_
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 30
    }

    Rectangle {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 15
      height: 1
      color: "#424246"
    }

    Process {
      id: process
      onReadyRead: console.info(readAll());
      onReadyReadStandardError: console.info(readAllStandardError());

      onFinished: {
        // Go back to home page
        console.info('Contact has finished the call');
        process.terminate();
        contactUser.state = "None";
      }
    }
}
