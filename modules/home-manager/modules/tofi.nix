{ ... }:

{
  flake.homeModules.tofi =
    { config, ... }:
    {
      programs.tofi = {
        enable = true;
        settings = {
          font = "${config.home.homeDirectory}/.nix-profile/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFontMono-Regular.ttf";
          hint-font = false;
          ascii-input = true;

          width = "100%";
          height = "100%";
          border-width = 0;
          outline-width = 0;
          num-results = 5;
          background-color = "#000A";

          padding-left = "45%";
          padding-top = "36%";
          result-spacing = 15;
          prompt-text = ''""'';
          hide-cursor = true;
          text-cursor = true;
          text-cursor-corner-radius = 1;
          default-result-color = "#757575";
          selection-color = "#FFF";
        };
      };
    };
}
