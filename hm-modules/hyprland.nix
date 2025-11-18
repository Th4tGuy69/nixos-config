{
  pkgs,
  inputs,
  system,
  ...
}:

let
  # Define reusable variables
  terminal = "ghostty";
  fileManager = "nautilus";
  # launcher = "sherlock";
  launcher = "anyrun"; # Broken rn
  # launcher = "walker";
  #launcher = "tofi-drun | xargs hyprctl dispatch exec --";
  #screenshot = "hyprshot --clipboard-only -m region";
  screenshot = "grimblast copy area";

  # Appearance options
  gapsIn = 1;
  gapsOut = 2;
  borderSize = 0;
  rounding = 10;
  activeOpacity = 1.0;
  inactiveOpacity = 1.0;
  shadowEnabled = false;
  blurEnabled = true;
  blurSize = 2;
  blurPasses = 2;
  vibrancy = 0.1696;

  hyprwatch = import ../packages/hyprwatch.nix { pkgs = pkgs; };
  nerdshade = import ../packages/nerdshade.nix { pkgs = pkgs; };
in

{
  imports = [
    #./hyprpanel.nix
    ./eww.nix
    ./anyrun.nix
    # ./walker.nix
    # ./sherlock.nix
    ./hyprwinwrap.nix
    ./hyprsunset.nix
    # ./hyprfocus.nix
    # ./hyprdarkwindow.nix
    # ./hyprchroma.nix
  ];

  home.packages = with pkgs; [
    hyprnotify
    hyprpolkitagent
    hyprpicker
    wl-clipboard
    #hyprwatch
    nerdshade
    grimblast

    # For background
    kitty
    clock-rs
  ];

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${system}.hyprland;
    portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

    settings = {
      "$mod" = "SUPER"; # Set the main modifier key

      ecosystem.no_update_news = true; # Disable update dialog

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
        # layout = "scrolling";
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
          "easeOutExpo, 0.16, 1, 0.3, 1"
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
        ];
      };

      # Input settings
      input = {
        kb_layout = "us";
        repeat_rate = 35;
        repeat_delay = 200;

        sensitivity = -0.5;
        accel_profile = "flat";
      };

      dwindle = {
        smart_split = true;
      };

      exec-once = [
        # Startup Services
        "systemctl --user start hyprpolkitagent"
        "systemctl --user enable --now hyprsunset.service"
        # Background
        # "${pkgs.kitty}/bin/kitten panel --edge=background ${pkgs.clock-rs}/bin/clock-rs -bts --fmt '%A, %B %d, %Y'"
        # Startup apps
        "zen"
        "discord"
        "spotify"
        "steam -silent"
        "nerdshade -loop -gammaNight 75 -latitude 44.564568 -longitude -123.262047 -tempNight 1600"
      ];

      windowrule = [

        # Ignore maximize requests from apps. You'll probably like this.
        "match:class:.*,suppressevent:maximize"
        # Fix some dragging issues with XWayland
        "match:class:^$; title:^$; xwayland:1; floating:1; fullscreen:0; pinned:0, nofocus"
        # Start apps on primary monitor
        "match:class:zen, monitor:DP-3"
        # Start apps on second monitor
        "match:class:goofcord, monitor:HDMI-A-1"
        "match:class:discord, monitor:HDMI-A-1"
        "match:class:Spotify, monitor:HDMI-A-1"
        # Give floating windows a border
        "match:floating:1, bordercolor:rgba(FFFFFF99) rgba(FFFFFF33)"
        "match:floating:1, bordersize:2"
        # Float file picker
        "match:class:xdg-desktop-portal-gtk, float"
        # Float Prism windows
        "match:class:org.prismlauncher.PrismLauncher, float"
        # Disable animations for app launcher
        "match:class:tofi-drun, noanim:1"
        # Float Qalculate
        "match:class:qalculate-gtk, float"
        # QEMU
        "match:title:QEMU, fullscreen"
        # Unity Popups
        "match:title:UnityEditor.Searcher.SearcherWindow, allowsinput"
        "match:title:Color, move:cursor -50% -5%"
        "match:title:Project Settings, center"
        # Android Emulator
        "match:title:Android Emulator, size:479 1038"
        "match:title:Android Emulator, maxsize:472 1038"
        "match:title:Android Emulator, minsize:472 1038"
        # Zed
        "match:class:dev.zed.Zed, renderunfocused"

        # Games
        # Fix Steam Big Picture for Steam link
        "match:title:Steam Big Picture Mode, maxsize:1920 1080"
        "match:title:Steam Big Picture Mode, minsize:1920 1080"
        "match:title:Steam Big Picture Mode, float"
        "match:title:Steam Big Picture Mode, fullscreenstate:3 *"
        # Allow tearing on all steam games
        "match:class:(steam_app).*, immediate"
        # Elden Ring Nightreign
        "match:class:steam_app_2622380, renderunfocused"
        "match:class:steam_app_2622380, fullscreenstate:* 3"
        # CS2
        "match:class:cs2, immediate"
        # TF2
        "match:class:tf_linux64, immediate"
      ];

      # Keybindings
      bind = [
        "SUPER, q, exec, ${terminal}"
        "SUPER SHIFT, q, exec, kitty"
        "SUPER, e, exec, ${fileManager}"
        "SUPER, space, exec, ${launcher}"
        "SUPER SHIFT, s, exec, ${screenshot}"
        "SUPER, c, exec, hyprpicker -a"
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
        "SUPER SHIFT, down, movewindow, d"
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

      monitor = [
        "DP-3, preferred, 0x0, 1"
        "desc:LG Electronics 27GL650F 008NTHM5V961, preferred, -1080x-56, 1, transform, 1"
        "desc:Hisense Electric Co. Ltd. HISENSE 0x00000001, 3840x2160@60, 0x0, 2"
        ", preferred, auto, 1"
      ];
    };
  };
}
