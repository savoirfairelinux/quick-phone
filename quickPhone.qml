import QtQuick 2.1
import QtQuick.Controls 1.0
import "content"
import "app.js" as JS

ApplicationWindow {
    id: appWindow

    visible: true
    width: 1024
    height: 600

    color: "#293133"

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

          Timer {
            id: directoryIddleTimer

            interval: 20 * 1000
            running: false
            repeat: true
            onTriggered: {
              directoryPage.reset();
              headerBar.visible = false;
              stackView.pop();
            }
          }
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
