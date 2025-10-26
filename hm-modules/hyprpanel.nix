{ inputs, ... }:

{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];
 
  programs.hyprpanel = {
    overlay.enable = true;
    enable = false;
    systemd.enable = true;
    hyprland.enable = true;
    theme = "monochrome";
    layout = {
      "bar.layouts" = {
        "0" = {
          left = [  ];
          middle = [  ];
          right = [ "notifications" ];
        };
        "1" = {
          left = [  ];
          middle = [  ];
          right = [ "notifications" ];
        };
      };
    };
    settings = {
      bar.launcher.autoDetectIcon = true;
      menus = {
        clock = {
          time.hideSeconds = true;
          weather.unit = "imperial";
        };
        dashboard = {
          
        };
      };
      theme = {
        bar.transparent = true;
      };
    };
  };
}
