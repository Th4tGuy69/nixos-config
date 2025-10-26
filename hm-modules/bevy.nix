{ pkgs, ... }:

let
  bevy-script = pkgs.writeShellScriptBin "bevy-dev-script" ''
    #!/bin/bash
    mkdir /tmp/bevy
    cd /home/thatguy/Documents/GitHub/bevy-game
    zeditor .
  '';
in

{
  xdg.desktopEntries.bevy = {
    name = "Bevy Game";
    exec = "${bevy-script}/bin/bevy-dev-script";
    type = "Application";
    categories = [ "Utility" "Development" ];
    terminal = true;
    icon = "utilities-terminal";
  }; 
}
