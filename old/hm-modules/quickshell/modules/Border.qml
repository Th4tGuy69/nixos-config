import "root:/config"
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
  id: root

  required property Bar top
  required property Bar bottom
  required property Bar left
  required property Bar right

  color: Colors.background
  WlrLayershell.layer: WlrLayer.Bottom

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  WrapperRectangle {
    anchors.fill: parent
    color: Colors.transparent

    topMargin: (root.top.height - Styles.borderWidth) / 2
    bottomMargin: (root.bottom.height - Styles.borderWidth) / 2
    leftMargin: (root.left.width - Styles.borderWidth) / 2
    rightMargin: (root.right.width - Styles.borderWidth) / 2

    Rectangle {
      radius: Styles.radius * 2
      color: Colors.transparent
      border.color: Colors.border
      border.width: Styles.borderWidth
    }
  }
}
