{ pkgs, ... }:

let
  seanime = import ../packages/seanime.nix { pkgs = pkgs; };
in
  
{
  home.packages = [ seanime ];

  wayland.windowManager.hyprland.settings.exec-once = [ "seanime" ];
}
