{ ... }:

{
  flake.homeModules.quickshell-shell =
    { pkgs ? import <nixpkgs> {} }:
    {
      packages = [
        pkgs.qt6.qmlformat
      ];
    };
}
