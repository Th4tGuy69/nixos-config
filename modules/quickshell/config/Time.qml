// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  function now(format: string): string {
    return Qt.formatDateTime(clock.date, format);
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}
