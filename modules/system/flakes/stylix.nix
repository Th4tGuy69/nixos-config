{ inputs, ... }:

{
  flake.nixosModules.stylix =
    { ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;

        base16Scheme = {
          base00 = "000000"; # Default Background (pure black for OLED)
          base01 = "171717"; # Lighter Background (very dark gray)
          base02 = "2e2e2e"; # Selection Background (dark gray)
          base03 = "4b4b4b"; # Comments, Invisibles (medium gray)
          base04 = "787878"; # Dark Foreground (medium gray)
          base05 = "a0a0a0"; # Default Foreground (light gray - OLED safe)
          base06 = "b8b8b8"; # Light Foreground (lighter gray - OLED safe)
          base07 = "d0d0d0"; # Light Background (light gray - OLED safe)
          base08 = "e53e3e"; # Variables, XML Tags, Markup Link Text (coral/red)
          base09 = "dd6b20"; # Integers, Boolean, Constants (orange)
          base0A = "f6e05e"; # Classes, Markup Bold, Search Text Background (light yellow)
          base0B = "48bb78"; # Strings, Inherited Class, Markup Code (mint green)
          base0C = "38b2ac"; # Support, Regular Expressions (teal)
          base0D = "4299e1"; # Functions, Methods, Attribute IDs (sky blue)
          base0E = "9f7aea"; # Keywords, Storage, Selector (purple)
          base0F = "ed64a6"; # Deprecated, Opening/Closing Embedded Language Tags (pink)
        };

        targets = {
          plymouth.enable = false;
          regreet.enable = false;
        };
      };
    };
}
