{ pkgs, ... }:

{
  stylix = {
    enable = true;

    targets = {
      vscode.enable = false;
      zed.enable = false;
      starship.enable = false;
      helix.enable = false;

      zen-browser.profileNames = [ "That Guy" ];
    };

    # base16Scheme = { # Poimandres original
    #   base00 = "1a1a1a"; # Default Background (dark gray from bottom row)
    #   base01 = "2d3748"; # Lighter Background (slate gray)
    #   base02 = "4a5568"; # Selection Background (medium slate)
    #   base03 = "718096"; # Comments, Invisibles (lighter slate)
    #   base04 = "a0aec0"; # Dark Foreground (light blue-gray)
    #   base05 = "e2e8f0"; # Default Foreground (very light blue)
    #   base06 = "f7fafc"; # Light Foreground (almost white)
    #   base07 = "ffffff"; # Light Background (pure white)
    #   base08 = "e53e3e"; # Variables, XML Tags, Markup Link Text (coral/red)
    #   base09 = "dd6b20"; # Integers, Boolean, Constants (orange)
    #   base0A = "f6e05e"; # Classes, Markup Bold, Search Text Background (light yellow)
    #   base0B = "48bb78"; # Strings, Inherited Class, Markup Code (mint green)
    #   base0C = "38b2ac"; # Support, Regular Expressions (teal)
    #   base0D = "4299e1"; # Functions, Methods, Attribute IDs (sky blue)
    #   base0E = "9f7aea"; # Keywords, Storage, Selector (purple)
    #   base0F = "ed64a6"; # Deprecated, Opening/Closing Embedded Language Tags (pink)
    # };

    # base16Scheme = { # Poimandres Black
    #   base00 = "000000"; # Default Background (pure black for OLED)
    #   base01 = "171717"; # Lighter Background (very dark gray)
    #   base02 = "2e2e2e"; # Selection Background (dark gray)
    #   base03 = "4b4b4b"; # Comments, Invisibles (medium gray)
    #   base04 = "787878"; # Dark Foreground (medium gray)
    #   base05 = "a0a0a0"; # Default Foreground (light gray - OLED safe)
    #   base06 = "b8b8b8"; # Light Foreground (lighter gray - OLED safe)
    #   base07 = "d0d0d0"; # Light Background (light gray - OLED safe)
    #   base08 = "e53e3e"; # Variables, XML Tags, Markup Link Text (coral/red)
    #   base09 = "dd6b20"; # Integers, Boolean, Constants (orange)
    #   base0A = "f6e05e"; # Classes, Markup Bold, Search Text Background (light yellow)
    #   base0B = "48bb78"; # Strings, Inherited Class, Markup Code (mint green)
    #   base0C = "38b2ac"; # Support, Regular Expressions (teal)
    #   base0D = "4299e1"; # Functions, Methods, Attribute IDs (sky blue)
    #   base0E = "9f7aea"; # Keywords, Storage, Selector (purple)
    #   base0F = "ed64a6"; # Deprecated, Opening/Closing Embedded Language Tags (pink)
    # };

    base16Scheme = {
      # Carbonfox
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
}
