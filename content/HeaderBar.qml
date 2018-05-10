import QtQuick 2.7
import QtQuick.Controls 2.0

BorderImage {
    border.bottom: 8
    source: "../img/toolbar.png"
    width: parent.width
    height: 100

    Rectangle {
        id: backButton
        width: opacity ? 60 : 0
        anchors.left: parent.left
        anchors.leftMargin: 20
        opacity: stackView.depth > 1 ? 1 : 0
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        height: 60
        radius: 4
        color: backmouse.pressed ? "#222" : "transparent"
        Behavior on opacity { NumberAnimation{} }
        Image {
            anchors.verticalCenter: parent.verticalCenter
            source: "../img/navigation_previous_item.png"
        }
        MouseArea {
            id: backmouse
            anchors.fill: parent
            anchors.margins: -50

            onClicked: {
              stackView.pop();
              directoryPage.reset();
              headerBar.visible = false;
            }
        }
    }

    Text {
      id: timeText
      color: "white"
      font.pixelSize: 42

      anchors.verticalCenter: parent.verticalCenter
      anchors.right: parent.right
      anchors.rightMargin: 30

      Timer {
        id: timer
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: timeText.text = Qt.formatDateTime(new Date(),"dddd d MMMM hh:mm")
      }
    }
}
