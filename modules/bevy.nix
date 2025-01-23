{ pkgs, ... }:

let
  bevy-script = pkgs.writeShellScriptBin "bevy-dev-script" ''
    #!/bin/bash
    mkdir /tmp/rust-rover
    cd /home/thatguy/Documents/GitHub/bevy-game
    nix-shell ./shell.nix
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
