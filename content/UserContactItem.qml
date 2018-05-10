import QtQuick 2.7

Item {
    id: contactUser

    width: parent.width
    height: 88

    property alias username: usernameText.text
    property alias userphone: userphoneText.text

    signal clicked
    signal pressed

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Rectangle {
        anchors.fill: parent
        color: "#11ffffff"
        visible: mouseArea.pressed
    }

    Text {
        id: usernameText
        color: "white"
        font.pixelSize: 32
        text: modelData
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 30
    }

    Text {
        id: userphoneText
        visible: false
        color: "white"
        font.pixelSize: 32
        text: modelData
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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: contactUser.clicked();
        onPressed: contactUser.pressed();
    }
}
