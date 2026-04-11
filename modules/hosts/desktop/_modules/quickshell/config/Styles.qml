pragma Singleton

import Quickshell
import QtQuick

Singleton {
  readonly property real margin: 3
  readonly property real radius: 10
  readonly property real borderWidth: 2
  readonly property real barScale: 2 / 3
  readonly property real barSpan: Math.min(Screen.width, Screen.height) * barScale
}
