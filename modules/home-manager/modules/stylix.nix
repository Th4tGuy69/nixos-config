{ ... }:

{
  flake.homeModules.stylix =
    { pkgs, ... }:
    {
      stylix = {
        enable = true;

        targets = {
          vscode.enable = false;
          zed.enable = false;
          starship.enable = false;
          helix.enable = false;
          zen-browser.enable = false;
        };

        base16Scheme = {
          base00 = "161616";
          base01 = "0c0c0c";
          base02 = "1c3736";
          base03 = "2a2a2a";
          base04 = "7b7c7e";
          base05 = "f2f4f8";
          base06 = "f9fbff";
          base07 = "e4e4e5";
          base08 = "ee5396";
          base09 = "f16da6";
          base0A = "08bdba";
          base0B = "25be6a";
          base0C = "33b1ff";
          base0D = "78a9ff";
          base0E = "be95ff";
          base0F = "2dc7c4";
        };

        fonts = with pkgs; {
          serif = {
            package = corefonts;
            name = "Calibri";
          };

          sansSerif = {
            package = vista-fonts;
            name = "Arial";
          };

          monospace = {
            package = nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Mono";
          };

          emoji = {
            package = twemoji-color-font;
            name = "Twitter-Color-Emoji-SVGinOT";
          };
        };

        cursor = {
          name = "Posy_Cursor_Strokeless";
          size = 12;
          package = pkgs.posy-cursors;
        };

        icons = {
          enable = true;
          dark = "Colloid-Grey-Dark";
          light = "Colloid-Grey-Light";
          package = pkgs.colloid-icon-theme.override { colorVariants = [ "grey" ]; };
        };
      };
    };
}
