{ pkgs, inputs, ... }:

{
  imports = [ inputs.niri.homeModules.niri ];

  home.packages = with pkgs; [
    xwayland-satellite-unstable
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;

    settings = { };
  };
}
