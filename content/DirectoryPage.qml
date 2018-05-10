import QtQuick 2.7
import QtQuick.Controls 2.0

import "../content"
import "../app.js" as JS

Item {
    width: parent.width
    height: parent.height

    signal reset
    onReset: userListModelView.reset();

    ListView {
      id: userListModelView

      anchors.fill: parent

      model: userListModel

      clip: true

      signal reset
      onReset: positionViewAtBeginning();

      delegate: UserContactItem {
        username: name
        userphone: ext
        onClicked: {
          // Load UserContactCard Component
          JS.createContactCard(name, ext, jobTitle, team, "./pictures/" + ext + ".png");
          directoryIddleTimer.stop();
        }
        onPressed: directoryIddleTimer.restart();
      }
    }
}
