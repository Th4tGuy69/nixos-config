{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wineWowPackages.stable
    #wineWowPackages.waylandFull
    winetricks
  ];
}
