{ pkgs, inputs, system, ... }:

let
  # Define reusable variables
  terminal = "ghostty";
  fileManager = "nautilus";
  launcher = "sherlock";
  # launcher = "anyrun";
  #launcher = "tofi-drun | xargs hyprctl dispatch exec --";
  #screenshot = "hyprshot --clipboard-only -m region";
  screenshot = "grimblast copy area";

  # Appearance options
  gapsIn = 6;
  gapsOut = 0;
  borderSize = 0;
  rounding = 12;
  activeOpacity = 1.0;
  inactiveOpacity = 1.0;
  shadowEnabled = false;
  blurEnabled = true;
  blurSize = 2;
  blurPasses = 2;
  vibrancy = 0.1696;

  # Extra options
  extraOptions = ''
# Startup apps
exec-once = systemctl --user start hyprpolkitagent
exec-once = systemctl --user enable --now hyprsunset.service

#exec-once = hyprpanel
exec-once = zen
exec-once = discord
exec-once = spotify
exec-once = seanime
exec-once = steam -silent
exec-once = nerdshade -loop -gammaNight 75 -latitude 44.564568 -longitude -123.262047 -tempNight 1600
exec-once = quickshell

# Window Rules
# Ignore maximize requests from apps. You'll probably like this.
windowrulev2 = suppressevent maximize, class:.*
# Fix some dragging issues with XWayland
windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Start apps on primary monitor
windowrulev2 = monitor DP-3, class:zen
# Start apps on second monitor
windowrulev2 = monitor HDMI-A-1, class:goofcord
windowrulev2 = monitor HDMI-A-1, class:discord
windowrulev2 = monitor HDMI-A-1, class:Spotify
# Float file picker
windowrulev2 = float, class:xdg-desktop-portal-gtk
# Float Prism windows
windowrulev2 = float, class:org.prismlauncher.PrismLauncher
# Disable animations for app launcher
windowrulev2 = noanim 1, class:tofi-drun
# Float Qalculate
windowrulev2 = float, class:qalculate-gtk
# QEMU
windowrulev2 = fullscreen, title:QEMU
# Unity Popups
windowrulev2 = allowsinput, title:UnityEditor.Searcher.SearcherWindow
windowrulev2 = move cursor -50% -5%, title:Color
windowrulev2 = center, title:Project Settings
# Android Emulator
windowrulev2 = size 479 1038, title:Android Emulator
windowrulev2 = maxsize 472 1038, title:Android Emulator
windowrulev2 = minsize 472 1038, title:Android Emulator
# Zed
windowrulev2 = renderunfocused, class:dev.zed.Zed

# Games
# Allow tearing on all steam games
windowrulev2 = immediate, class:(steam_app).*
# Elden Ring Nightreign
windowrulev2 = renderunfocused, class:steam_app_2622380
windowrulev2 = fullscreenstate:* 3, class:steam_app_2622380
# CS2
windowrulev2 = immediate, class:cs2
# TF2
windowrulev2 = immediate, class:tf_linux64

# Hyprchroma (transparency)
# windowrulev2 = plugin:chromakey, fullscreen:0 chromakey_background = 7,8,17

# Monitors
monitor = DP-3, preferred, 0x0, 1
monitor = desc:LG Electronics 27GL650F 008NTHM5V961, preferred, -1080x-430, 1, transform, 1
monitor = desc:Hisense Electric Co. Ltd. HISENSE 0x00000001, 3840x2160@60, 0x0, 2
monitor = , preferred, auto, 1
  '';

  hyprwatch = import ../packages/hyprwatch.nix { pkgs = pkgs; };
  nerdshade = import ../packages/nerdshade.nix { pkgs = pkgs; };
in 

{
  imports = [ 
    #./hyprpanel.nix
    ./eww.nix
    # ./anyrun.nix
    ./sherlock.nix
  ];

  home.packages = with pkgs; [
    hyprnotify
    hyprpolkitagent
    hyprpicker
    wl-clipboard
    #hyprwatch
    nerdshade
  ];

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = with inputs.hyprland-plugins.packages.${system}; [
      # inputs.hyprchroma.packages.${system}.Hypr-DarkWindow # Doesn't seem to work
      hyprfocus
      hyprwinwrap
    ];

    settings = {
      "$mod" = "SUPER"; # Set the main modifier key

      # General settings
      general = {
        "gaps_in" = gapsIn;
        "gaps_out" = gapsOut;
        "border_size" = borderSize;
        #"col.active_border" = activeBorderColor;
        #"col.inactive_border" = inactiveBorderColor;
        "resize_on_border" = false;
        "allow_tearing" = true;
        "layout" = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = rounding;
        active_opacity = activeOpacity;
        inactive_opacity = inactiveOpacity;
        shadow = {
          enabled = shadowEnabled;
          range = 4;
          render_power = 3;
          # color = shadowColor;
        };
        blur = {
          enabled = blurEnabled;
          size = blurSize;
          passes = blurPasses;
          vibrancy = vibrancy;
        };
      };

      misc = {
      	disable_hyprland_logo = true;
        #background_color = "rgba(000000FF)";
        middle_click_paste = false;
        vrr = 3;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      cursor = {
        hide_on_key_press = true;
      };

      # Animation settings
      animations = {
        enabled = "yes, please :)";

        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1.0"
          "quick, 0.15, 0, 0.1, 1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "layers, 1, 3.81, easeOutQuint"
          "workspaces, 1, 1.94, almostLinear, fade"
          "animation = hyprfocusIn, 1, 1.7, easeOutExpo"
          "animation = hyprfocusOut, 1, 1.7, easeOutExpo"
        ];
      };

      # Input settings
      input = {
        "kb_layout" = "us";
        follow_mouse = 1;
        sensitivity = -0.5;
        accel_profile = "flat";
      };

      dwindle = {
        preserve_split = "true";
      };

      # Keybindings
      bind = [
        "SUPER, q, exec, ${terminal}"
        "SUPER SHIFT, q, exec, kitty"
        "SUPER, e, exec, ${fileManager}"
        "SUPER, space, exec, ${launcher}"
        "SUPER SHIFT, s, exec, ${screenshot}"
        "SUPER, c, exec, hyprpicker -a"
        #"SUPER SHIFT, c, togglechromakey"
	      "SUPER, w, killactive,"
        "SUPER, f, fullscreen,"
        "SUPER SHIFT, f, togglefloating,"
        "SUPER, m, exit,"
        "SUPER, p, pseudo,"
        "SUPER, s, togglesplit,"
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
	      "SUPER SHIFT, left, movewindow, l"
	      "SUPER SHIFT, right, movewindow, r"
	      "SUPER SHIFT, up, movewindow, u"
	      "SUPER SHIFT, down, movefocus, d"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
	      "SUPER, escape, togglespecialworkspace, magic"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
	      "SUPER SHIFT, escape, movetoworkspace, special:magic"
	
        # Global keybind passthrough
        ", insert, sendshortcut, CTRL SHIFT, d, class:discord"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ]; 
    };

    extraConfig = extraOptions;
  };
 }

