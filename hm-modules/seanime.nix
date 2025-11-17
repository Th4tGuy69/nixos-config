{ pkgs, ... }:

let
  seanime = import ../packages/seanime.nix { pkgs = pkgs; };
  seanime-denshi = import ../packages/seanime-denshi.nix { pkgs = pkgs; };
in
  
{
  home.packages = [ seanime seanime-denshi ];

  # wayland.windowManager.hyprland.settings.exec-once = [ "seanime" ];
}
