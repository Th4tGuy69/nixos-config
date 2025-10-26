{ pkgs, config, inputs, system, ... }:
let
  quickshellDir = ./quickshell;
  c = config.lib.stylix.colors.withHashtag;
  colors = pkgs.writeText "Colors.qml" ''
// Managed by Home Manager
pragma Singleton
import Quickshell
import QtQuick
Singleton {
  // Base16 Color Scheme (Default Dark)
  readonly property color base00: "${c.base00}"
  readonly property color base01: "${c.base01}"
  readonly property color base02: "${c.base02}"
  readonly property color base03: "${c.base03}"
  readonly property color base04: "${c.base04}"
  readonly property color base05: "${c.base05}"
  readonly property color base06: "${c.base06}"
  readonly property color base07: "${c.base07}"
  readonly property color base08: "${c.base08}"
  readonly property color base09: "${c.base09}"
  readonly property color base0A: "${c.base0A}"
  readonly property color base0B: "${c.base0B}"
  readonly property color base0C: "${c.base0C}"
  readonly property color base0D: "${c.base0D}"
  readonly property color base0E: "${c.base0E}"
  readonly property color base0F: "${c.base0F}"
  // Convenience aliases for common UI elements
  readonly property color background: base00
  readonly property color surface: base01
  readonly property color border: base02
  readonly property color comment: base03
  readonly property color foreground: base05
  readonly property color text: base05
  readonly property color accent: base0D
  readonly property color error: base08
  readonly property color warning: base09
  readonly property color success: base0B
  readonly property color transparent: "transparent"
}
  '';
  colorsDir = pkgs.runCommand "colors-dir" {} ''
    mkdir -p $out/config
    cp ${colors} $out/config/Colors.qml
  '';
  quickshellConfig = pkgs.symlinkJoin {
    name = "quickshell-config";
    paths = [ quickshellDir colorsDir ];
  };
in
{
  home.packages = [ inputs.quickshell.packages.${system}.default ];
  
  home.activation.copyQuickshellConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    rm -rf $HOME/.config/quickshell
    cp -rL ${quickshellConfig} $HOME/.config/quickshell
    chmod -R 755 $HOME/.config/quickshell
  '';
}
