{ pkgs, ... }:

let
  future-cyan-hyprcursor = import ../packages/future-cyan-hyprcursor.nix { pkgs = pkgs; };
in

{
  home.pointerCursor = {
    enable = true;
    name = "Future-Cyan-Hyprcursor_Theme";
    package = future-cyan-hyprcursor;
    hyprcursor.enable = true;
    hyprcursor.size = 64;
    #gtk.enable = true;
  };
}
