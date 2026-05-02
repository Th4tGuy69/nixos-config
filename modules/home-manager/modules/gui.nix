{ lib, ... }:

{
  flake.homeModules.gui =
    { config, ... }:
    {
      options.gui = {
        windowManager = lib.mkOption {
          type = lib.types.str;
          default = "hyprland";
          description = "Window manager to use (hyprland, niri, scroll)";
        };
        bar = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Bar to use (hyprpanel, eww, quickshell, null for none)";
        };
        runner = lib.mkOption {
          type = lib.types.str;
          default = "anyrun";
          description = "Application runner (anyrun, sherlock)";
        };
        terminal = lib.mkOption {
          type = lib.types.str;
          default = "ghostty";
          description = "Terminal emulator to use";
        };
        fileManager = lib.mkOption {
          type = lib.types.str;
          default = "nautilus";
          description = "File manager to use";
        };
        monitors = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
          description = "Monitor configuration";
        };
        startupApps = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Applications to start on login";
        };
      };
    };
}
