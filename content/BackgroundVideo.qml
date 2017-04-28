import QtQuick 2.1
import QtMultimedia 5.4

Item{

  property string videoSource
  anchors.fill: parent

  // When setting loop property of MediaPlayer, there is a black screen
  // etween each loop.
  // As a workaround, we use two MediaPlayer playing the same video
  // and switch between them on video sample end.

  MediaPlayer {
    id: player1
    source: videoSource
    autoLoad: true
    autoPlay: true
    muted: true
    onStatusChanged: {
      if(status == MediaPlayer.EndOfMedia){
        player2.play()
        container1.z = 2
        container2.z = 3
        player1.seek(0)
        player1.play()
        player1.pause()
      }
    }
  }

  MediaPlayer {
    id: player2
    source: videoSource
    autoLoad: true
    muted: true
    onStatusChanged: {
      if(status == MediaPlayer.EndOfMedia){
        player1.play()
        container1.z = 3
        container2.z = 2
        player2.seek(0)
        player2.play()
        player2.pause()
      }
      else if (status == MediaPlayer.Loaded){
        player2.play()
        player2.pause()
      }
    }
  }

  Item {
    id: container2
    z: 2
    anchors.fill: parent
    VideoOutput {
      id: output2
      source: player2
      anchors.fill: parent
    }
  }

  Item {
    id: container1
    z: 3
    anchors.fill: parent
    VideoOutput {
      id: output1
      source: player1
      anchors.fill: parent
    }
  }
}
