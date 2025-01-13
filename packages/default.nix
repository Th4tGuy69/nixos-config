let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/master";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

{
  hyprwatch = pkgs.callPackage ./hyprwatch.nix {};
}
