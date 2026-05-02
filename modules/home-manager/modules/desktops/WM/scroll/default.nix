{ config, lib, pkgs, inputs, ... }:

{
  flake.homeModules.scroll =
    { pkgs, config, inputs, ... }:
    let
      term = config.gui.terminal or "ghostty";
      menu = config.gui.runner or "anyrun";
      filemanager = config.gui.fileManager or "nautilus";
      
      monitorConfig = m:
        let
          name = if m.name != null then m.name else m.description;
          res = if m.preferred then "preferred" 
                else "${toString m.width}x${toString m.height}" + 
                     lib.optionalString (m.refreshRate != null) "@${toString m.refreshRate}Hz";
        in
        ''output ${name} resolution ${res} position ${toString (m.x or 0)},${toString (m.y or 0)} transform ${toString (m.transform or 0)}'';
      
      scrollConfig = ''
        # vim: ft=swayconfig
        #
        # Default config for scroll
        #

        ### Variables
        #
        # Logo key. Use Mod1 for Alt.
        set $mod Mod4
        # Home row direction keys, like vim
        set $left Left
        set $down Down
        set $up Up
        set $right Right
        # Your preferred terminal emulator
        set $term ${term}
        # Your preferred application launcher
        set $menu ${menu}
        # Your preferred file manager
        set $filemanager ${filemanager}

        ### Output configuration
        #
        ${lib.concatMapStringsSep "\n" monitorConfig config.gui.monitors}

        ### Input configuration
        #
        input type:keyboard {
            repeat_delay 200
            repeat_rate 35
        }

        input type:pointer {
            accel_profile flat
            pointer_accel -0.5
        }

        ### Windows defaults
        default_border pixel 0
        gaps inner 0
        gaps outer 0

        # Layout settings
        layout_default_width 0.5
        layout_default_height 1.0

        # Focus wrapping
        focus_wrapping no
      '';
    in
    {
      # Only enable if user imported this module
      home.sessionVariables = lib.mkIf (config.gui.windowManager == "scroll") {
        QT_QPA_PLATFORM = "wayland;xcb";
        GDK_BACKEND = "wayland,x11";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";

        XDG_CURRENT_DESKTOP = "scroll";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "scroll";

        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      };

      home.file.".config/scroll/config".text = lib.mkIf (config.gui.windowManager == "scroll") scrollConfig;
    };
}
