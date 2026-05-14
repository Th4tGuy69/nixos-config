{ ... }:

{
  flake.homeModules.scroll =
    {
      inputs,
      config,
      lib,
      pkgs,
      ...
    }:
    let
      term = config.gui.terminal;
      menu = config.gui.runner;
      filemanager = config.gui.fileManager;

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
      home.file.".config/scroll/config".text = scrollConfig;

      # programs.scroll = {
      #   enable = true;
      #   package = inputs.scroll-flake.packages.${pkgs.stdenv.hostPlatform.system}.scroll-git;

      #   extraSessionCommands = ''
      #     # Tell QT, GDK and others to use the Wayland backend by default, X11 if not available
      #     export QT_QPA_PLATFORM="wayland;xcb"
      #     export GDK_BACKEND="wayland,x11"
      #     export SDL_VIDEODRIVER=wayland
      #     export CLUTTER_BACKEND=wayland

      #     # XDG desktop variables to set scroll as the desktop
      #     export XDG_CURRENT_DESKTOP=scroll
      #     export XDG_SESSION_TYPE=wayland
      #     export XDG_SESSION_DESKTOP=scroll

      #     # Configure Electron to use Wayland instead of X11
      #     export ELECTRON_OZONE_PLATFORM_HINT=wayland
      #   '';
      # };

      xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
}
