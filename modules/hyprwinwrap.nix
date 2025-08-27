{ pkgs, ... }:

let
  clock-bg = pkgs.writeShellScriptBin "clock-bg" ''
    #!${pkgs.bash}/bin/bash  
    clock-rs -bt --fmt "%A, %B %d, %Y"
  '';  
in

{
  home.packages = [ pkgs.clock-rs pkgs.kitty ];

  wayland.windowManager.hyprland.settings.exec-once = [
    "TZ=America/Los_Angeles ${pkgs.kitty}/bin/kitty --class 'clock-bg' ${clock-bg}/bin/clock-bg"
  ];

  wayland.windowManager.hyprland.settings.plugin.hyprwinwrap = {
    class = "clock-bg";
  };
}
