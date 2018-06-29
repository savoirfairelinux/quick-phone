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
      currentIndex: -1

      model: userListModel

      clip: true

      signal reset
      onReset: {
        positionViewAtBeginning();
        currentIndex = -1;
      }

      delegate: UserContactItem {
        id: item
        name_: name
        ext_: ext
        jobTitle_: jobTitle
        team_: team
        pictureLocation_: "../assets/pictures/" + ext + ".png"

        selected : ListView.isCurrentItem
        onClicked: {
          userListModelView.currentIndex = userListModelView.currentIndex === index ? -1 : index;
          item.state = ListView.isCurrentItem ? "Selected" : "None";
        }
        onPressed: directoryIddleTimer.restart();

        Connections{
          target: userListModelView
          onReset: state = "None";
        }
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
