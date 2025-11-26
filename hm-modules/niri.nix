{ pkgs, inputs, ... }:

{
  imports = [ inputs.niri.homeModules.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;

    settings = { };
  };
}
