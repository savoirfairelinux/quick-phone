import QtQuick 2.7
import QtQuick.Controls 2.0

import "../content"
import "../app.js" as JS

Item {
    width: parent.width
    height: parent.height

    signal reset
    onReset: userListModelView.reset();

    UserContactItem {
      id: defaultContact
      z: 500 // always on top of list

      width: parent.width
      username: "Accueil"
      userphone: "000"
      onClicked: {
        // Load UserContactCard Component
        JS.createContactCard("Accueil", "reception", "", "", "./img/reception_contact_picture.png");
        directoryIddleTimer.stop();
      }
      onPressed: directoryIddleTimer.restart();
    }

    ListView {
      id: userListModelView

      width: parent.width
      anchors.top: defaultContact.bottom
      anchors.bottom: parent.bottom

      model: userListModel

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
