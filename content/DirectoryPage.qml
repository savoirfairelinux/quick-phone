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
          directoryIddleTimer.stop();
          return loadContactCard(name, ext, jobTitle, team, "../assets/pictures/" + ext + ".png");
        }
        onPressed: directoryIddleTimer.restart();
      }
    }

  signal loadContactCard(string name, real ext, string jobTitle, string team, string pictureLocation)
  onLoadContactCard: {
    contactCard.name = name;
    contactCard.ext = ext;
    contactCard.jobTitle = jobTitle;
    contactCard.team = team;
    contactCard.pictureLocation = pictureLocation;

    contactCard.loader.active = true
  }

  ContactCardLoader {
    id: contactCard
  }
}
