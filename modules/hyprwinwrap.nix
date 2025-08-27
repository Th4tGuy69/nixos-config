{ pkgs, ... }:

let
  clock-bg = pkgs.writeShellScriptBin "clock-bg" ''
    #!${pkgs.bash}/bin/bash
    sleep 3s
    clock-rs -bt --fmt "%A, %B %d, %Y"
  '';  
in

{
  home.packages = [ pkgs.clock-rs pkgs.bash pkgs.kitty ];

  wayland.windowManager.hyprland.settings.exec-once = [
    "${pkgs.kitty}/bin/kitty --class 'clock-bg' ${clock-bg}/bin/clock-bg"
  ];

  wayland.windowManager.hyprland.settings.plugin.hyprwinwrap = {
    class = "clock-bg";
  };
}
