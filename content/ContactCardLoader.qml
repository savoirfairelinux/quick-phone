import QtQuick 2.7
import QtQuick.Window 2.2

Item {
  anchors.fill: parent

  property string name
  property real ext
  property string jobTitle
  property string team
  property string pictureLocation

  property alias loader: _loader

  Loader {
    id: _loader
    active: false
    anchors.fill: parent
    source: "./UserContactCard.qml"

    onLoaded: {
      item.componentLoaded(name, ext, jobTitle, team, pictureLocation);
    }
  }

  Connections {
    target: loader.item

    onCloseContactCard: {
      loader.active = false;
    }
  }
}
