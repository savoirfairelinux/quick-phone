import QtQuick 2.1
import QtQuick.Controls 1.0
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

      width: parent.width - 30
      username: "Accueil"
      userphone: "000"
      onClicked: {
        // Load UserContactCard Component
        JS.createContactCard("Accueil", "374", "", "", "./img/reception_contact_picture.png");
      }
    }

    ScrollView {
      anchors.fill: parent

      ListView {
        id: userListModelView

        model: userListModel
        anchors.top: defaultContact.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        signal reset
        onReset: positionViewAtBeginning();

        delegate: UserContactItem {
          username: name
          userphone: ext
          onClicked: {
            // Load UserContactCard Component
            JS.createContactCard(name, ext, jobTitle, team, "./pictures/" + ext + ".png");
          }
        }
      }
    }
}
