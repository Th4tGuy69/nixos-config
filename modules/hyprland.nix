{ programs, ... }:

let
  # Define reusable variables
  terminal = "ghostty";
  fileManager = "nautilus";
  launcher = "tofi-drun | xargs hyprctl dispatch exec --";

  # Appearance options
  gapsIn = 5;
  gapsOut = 20;
  borderSize = 2;
  rounding = 10;
  activeOpacity = 1.0;
  inactiveOpacity = 1.0;
  cursorTheme = "Future-cursors";
  cursorSize = 24;
  shadowOffset = "0 5";
  shadowColor = "rgba(1a1a1aee)";
  activeBorderColor = "rgba(33ccffee)";
  inactiveBorderColor = "rgba(595959aa)";
  blurEnabled = true;
  blurSize = 3;
  blurPasses = 1;
  vibrancy = 0.1696;

  # Extra options
  extraOptions = ''
# Startup apps
exec-once = zen
exec-once = discord
exec-once = spotify

# Window Rules
# Ignore maximize requests from apps. You'll probably like this.
windowrulev2 = suppressevent maximize, class:.*
# Fix some dragging issues with XWayland
windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
# Open apps on second monitor
windowrulev2 = monitor HDMI-A-1, class:discord
windowrulev2 = monitor HDMI-A-1, class:Spotify
# Float file picker
windowrulev2 = float, class:xdg-desktop-portal-gtk
# Float Prism windows
windowrulev2 = float, class:org.prismlauncher.PrismLauncher

# Environment Variables
env = XCURSOR_THEME,${toString cursorTheme}
env = XCURSOR_SIZE,${toString cursorSize}

# Monitors
monitor = DP-3, preferred, 0x0, 1
monitor = desc:LG Electronics 27GL650F 008NTHM5V961, preferred, -1080x-635, 1, transform, 1
monitor = , preferred, auto, 1
  '';
in 

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER"; # Set the main modifier key

      # General settings
      general = {
        "gaps_in" = gapsIn;
        "gaps_out" = gapsOut;
        "border_size" = borderSize;
        "col.active_border" = activeBorderColor;
        "col.inactive_border" = inactiveBorderColor;
        "resize_on_border" = false;
        "allow_tearing" = false;
        "layout" = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = rounding;
        active_opacity = activeOpacity;
        inactive_opacity = inactiveOpacity;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = shadowColor;
        };
        blur = {
          enabled = blurEnabled;
          size = blurSize;
          passes = blurPasses;
          vibrancy = vibrancy;
        };
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
        ", insert, pass, class:discord"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };

    extraConfig = extraOptions;
  };
 }

