{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wineWow64Packages.stable
    #wineWow64Packages.waylandFull
    winetricks
  ];
}
