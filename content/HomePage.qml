import QtQuick 2.7

Component {
  id: homePage

  Rectangle {
    anchors.fill: parent
    color: "#000000"

    MouseArea {
      anchors.fill: parent
      onClicked: {
        stackView.push(directoryPage);
        headerBar.visible = true;
        directoryIddleTimer.restart();
      }
    }

    BackgroundVideo {
      videoSource:  "../assets/intro_video.mp4"
    }

    Column {
      anchors.fill: parent
      spacing: 30

      Text {
        text: " "
        font.pixelSize: 80
        color: "White"
        anchors.horizontalCenter: parent.horizontalCenter
      }
      Text {
        text: "Bienvenue chez"
        font.pixelSize: 42
        color: "White"
        anchors.horizontalCenter: parent.horizontalCenter
      }

      Image {
        id: sflLogo
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../img/logo_white_text.png"
      }

      Text {
        text: "Appuyez pour appeler quelqu'un"
        font.pixelSize: 42
        color: "White"
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
  }
}
