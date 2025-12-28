{ pkgs, ... }:

{
  home.packages = [ pkgs.pinentry-all ];

  programs.rbw = {
    enable = true;
  };
}
