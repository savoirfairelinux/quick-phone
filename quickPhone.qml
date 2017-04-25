import QtQuick 2.1
import QtQuick.Controls 1.0
import "content"
import "app.js" as JS

ApplicationWindow {
    id: appWindow

    visible: true
    width: 800
    height: 600

    Rectangle {
        color: "#000000"
        anchors.fill: parent
    }

    toolBar: HeaderBar {
        id: headerBar
        visible: false
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: homePage

        HomePage {
          id: homePage
        }
        DirectoryPage {
          id: directoryPage
        }

        delegate: StackViewDelegate {
          pushTransition: StackViewTransition {
            PropertyAnimation {
              target: enterItem
              property: "opacity"
              from: 0
              to: 1
            }
            PropertyAnimation {
              target: exitItem
              property: "opacity"
              from: 1
              to: 0
            }
          }
        }
    }

    ListModel {
      id: userListModel
    }

    Component.onCompleted: JS.load();
}
