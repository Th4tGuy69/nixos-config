{ pkgs, inputs, system, ... }:

let
  QuickshellBar = pkgs.writeTextDir "shell.qml" ''
import Quickshell // for PanelWindow
import QtQuick // for Text

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: 30

  Text {
    // center the bar in its parent component (the window)
    anchors.centerIn: parent

    text: "hello world"
  }
}
  '';
in

{
  home.packages = [ inputs.quickshell.packages.${system}.default ];

  home.file.".config/quickshell/shell.qml".source = "${QuickshellBar}/shell.qml";
}
