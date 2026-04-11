import "root:/modules" as Modules

import QtQuick
import Quickshell

ShellRoot {
  Modules.Border {
    top: Modules.Bar {
      side: "top"
      content: Modules.Top {}
    }
    bottom: Modules.Bar {
      side: "bottom"
    }
    left: Modules.Bar {
      side: "left"
    }
    right: Modules.Bar {
      side: "right"
    }
  }
}
