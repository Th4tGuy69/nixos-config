{ ... }:

{
  programs.tofi = {
    enable = true;
    settings = {
      # Optimizations     
      font = "/home/thatguy/.nix-profile/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFontMono-Regular.ttf";
      hint-font = false;
      ascii-input = true;

      # Fullscreen theme
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      #padding-left = "35%";
      #padding-top = "35%";
      #result-spacing = 25;
      num-results = 5;
      background-color = "#000A";
    
      # Customizations
      padding-left = "45%";
      padding-top = "36%";
      result-spacing = 15;
      prompt-text = ''""'';
      hide-cursor = true;
      text-cursor = true;
      text-cursor-corner-radius = 1;
      # Colors
      default-result-color = "#757575";
      selection-color = "#FFF";
    };
  };
}
