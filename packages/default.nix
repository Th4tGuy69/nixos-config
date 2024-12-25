let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/master";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

{
  colloid-gtk-theme = pkgs.callPackage ./colloid-gtk-theme.nix {};
}
