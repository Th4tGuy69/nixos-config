{ inputs, ... }:

{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
 
  programs.hyprpanel = {
    overlay.enable = true;
    enable = true;
    systemd.enable = true;
    hyprland.enable = true;
    #settings = {};
  };
}
