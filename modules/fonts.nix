{ pkgs, ... }:

{
  home.packages = with pkgs; [
    corefonts
    vistafonts
    nerd-fonts.fira-code
    twemoji-color-font
  ];

  fonts.fontconfig = { 
    enable = true;
    defaultFonts = {
      serif = [ "Calibri" ];
      sansSerif = [ "Arial" ];
      monospace = [ "FiraCode-Nerd-Font-Mono" ];
      emoji = [ "Twitter-Color-Emoji-SVGinOT" ];
    };
  };
}

