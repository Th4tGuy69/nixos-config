import "root:/config"

import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

PanelWindow {
  id: root

  required property string side
  property Component content

  anchors {
    top: (side == "top" || side == "left" || side == "right") ? true : false
    bottom: (side == "bottom" || side == "left" || side == "right") ? true : false
    left: (side == "left" || side == "top" || side == "bottom") ? true : false
    right: (side == "right" || side == "top" || side == "bottom") ? true : false
  }

  color: "transparent"

  implicitWidth: rect.width + Styles.margin
  implicitHeight: rect.height + Styles.margin

  Rectangle { // Border gap
    anchors.centerIn: parent

    visible: content ? true : false

    color: Colors.background

    width: rect.width + Styles.margin
    height: rect.height + Styles.margin
  }

  WrapperRectangle {
    id: rect

    anchors.centerIn: parent

    visible: content ? true : false

    width: (side == "left" || side == "right") ? (loader.implicitWidth || 0) + (Styles.borderWidth * 2) + Styles.margin : Styles.barSpan

    height: (side == "top" || side == "bottom") ? (loader.implicitHeight || 0) + (Styles.borderWidth * 2) + Styles.margin : Styles.barSpan

    color: Colors.surface
    border.color: Colors.border
    border.width: Styles.borderWidth

    radius: Styles.radius

    WrapperRectangle {
      id: contentWrapper

      color: "transparent"

      margin: Styles.margin

      Loader {
        id: loader
        sourceComponent: content
      }
    }
  }
}
