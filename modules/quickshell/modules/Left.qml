import "root:/config"

import QtQuick
import Quickshell

Item {
  // Swapped due to rotation
  implicitWidth: text.implicitHeight
  implicitHeight: text.implicitWidth

  Text {
    id: text
    anchors.centerIn: parent
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: Time.now("hh:mm")
    font.family: Fonts.serif
    color: Colors.foreground
    rotation: -90
  }
}
