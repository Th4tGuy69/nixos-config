import "root:/config"

import QtQuick
import Quickshell
import Quickshell.Widgets

Text {
  id: text
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter
  text: Time.now("hh:mm")
  font.family: Fonts.serif
  color: Colors.foreground
}
