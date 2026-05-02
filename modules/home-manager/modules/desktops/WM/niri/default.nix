{ config, lib, pkgs, ... }:

{
  flake.homeModules.niri =
    { pkgs, config, inputs, ... }:
    let
      terminal = config.gui.terminal or "ghostty";
      launcher = config.gui.runner or "anyrun";
      
      monitorConfig = m:
        let
          name = if m.name != null then m.name else m.description;
        in
        {
          name = name;
          value = {
            enable = true;
            mode = {
              width = m.width;
              height = m.height;
              refresh = m.refreshRate;
            };
            scale = m.scale or 1.0;
            transform = {
              flipped = false;
              rotation = m.transform or 0;
            };
            position = {
              x = m.x or 0;
              y = m.y or 0;
            };
          };
        };
    in
    {
      # Only enable if user imported this module
      imports = lib.mkIf (config.gui.windowManager == "niri") [
        inputs.niri.homeModules.niri
      ];

      home.packages = lib.mkIf (config.gui.windowManager == "niri") (with pkgs; [
        xwayland-satellite-unstable
        swaylock
        playerctl
        brightnessctl
      ]);

      programs.niri = lib.mkIf (config.gui.windowManager == "niri") {
        enable = true;
        package = pkgs.niri-unstable;

        settings = {
          input = {
            keyboard = {
              xkb = {
                repeat-rate = 35;
                repeat-delay = 200;
              };
              numlock = true;
            };

            touchpad = {
              tap = true;
              natural-scroll = true;
            };

            trackpoint = {
            };

            mouse = {
            };
          };

          outputs = lib.mkIf (config.gui.windowManager == "niri") (builtins.listToAttrs (map monitorConfig config.gui.monitors));

          layout = {
            gaps = 16;
            center-focused-column = "never";

            preset-column-widths = [
              { proportion = 0.33333; }
              { proportion = 0.5; }
              { proportion = 0.66667; }
            ];

            default-column-width = {
              proportion = 0.5;
            };

            focus-ring = {
              enable = true;
              width = 4;
              active = {
                color = "#7fc8ff";
              };
              inactive = {
                color = "#505050";
              };
            };

            border = {
              enable = false;
              width = 4;
              active = {
                color = "#ffc87f";
              };
              inactive = {
                color = "#505050";
              };
              urgent = {
                color = "#9b0000";
              };
            };

            shadow = {
              enable = false;
              softness = 30.0;
              spread = 5.0;
              offset = {
                x = 0.0;
                y = 5.0;
              };
              color = "#0007";
            };

            struts = {
              left = 0;
              right = 0;
              top = 0;
              bottom = 0;
            };
          };

          spawn-at-startup = [
            { argv = [ "waybar" ]; }
          ];

          hotkey-overlay = {
            skip-at-startup = false;
          };

          prefer-no-csd = true;

          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          animations = {
            enable = true;
          };

          window-rules = [
            {
              matches = [
                { app-id = ''^org\.wezfurlong\.wezterm$''; }
              ];
              default-column-width = { };
            }
            {
              matches = [
                { app-id = ''firefox$''; }
                { title = "^Picture-in-Picture$"; }
              ];
              open-floating = true;
            }
          ];

          binds = with config.lib.niri.actions; {
            "Mod+Shift+Slash" = {
              action = show-hotkey-overlay;
            };

            "Mod+Q" = {
              action = spawn "${terminal}";
              hotkey-overlay.title = "Open a Terminal: ${terminal}";
            };
            "Mod+Space" = {
              action = spawn "${launcher}";
              hotkey-overlay.title = "Run an Application: ${launcher}";
            };
            "Super+Alt+L" = {
              action = spawn "${pkgs.swaylock}/bin/swaylock";
              hotkey-overlay.title = "Lock the Screen: swaylock";
            };

            "XF86AudioRaiseVolume" = {
              action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
              allow-when-locked = true;
            };
            "XF86AudioLowerVolume" = {
              action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
              allow-when-locked = true;
            };
            "XF86AudioMute" = {
              action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              allow-when-locked = true;
            };
            "XF86AudioMicMute" = {
              action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              allow-when-locked = true;
            };

            "XF86AudioPlay" = {
              action = spawn-sh "${pkgs.playerctl}/bin/playerctl play-pause";
              allow-when-locked = true;
            };
            "XF86AudioStop" = {
              action = spawn-sh "${pkgs.playerctl}/bin/playerctl stop";
              allow-when-locked = true;
            };
            "XF86AudioPrev" = {
              action = spawn-sh "${pkgs.playerctl}/bin/playerctl previous";
              allow-when-locked = true;
            };
            "XF86AudioNext" = {
              action = spawn-sh "${pkgs.playerctl}/bin/playerctl next";
              allow-when-locked = true;
            };

            "XF86MonBrightnessUp" = {
              action = spawn "brightnessctl" "--class=backlight" "set" "+10%";
              allow-when-locked = true;
            };
            "XF86MonBrightnessDown" = {
              action = spawn "brightnessctl" "--class=backlight" "set" "10%-";
              allow-when-locked = true;
            };

            "Mod+O" = {
              action = toggle-overview;
              repeat = false;
            };

            "Mod+W" = {
              action = close-window;
              repeat = false;
            };

            "Mod+Left" = {
              action = focus-column-left;
            };
            "Mod+Down" = {
              action = focus-window-down;
            };
            "Mod+Up" = {
              action = focus-window-up;
            };
            "Mod+Right" = {
              action = focus-column-right;
            };
            "Mod+H" = {
              action = focus-column-left;
            };
            "Mod+J" = {
              action = focus-window-down;
            };
            "Mod+K" = {
              action = focus-window-up;
            };
            "Mod+L" = {
              action = focus-column-right;
            };

            "Mod+Shift+Left" = {
              action = move-column-left;
            };
            "Mod+Shift+Down" = {
              action = move-window-down;
            };
            "Mod+Shift+Up" = {
              action = move-window-up;
            };
            "Mod+Shift+Right" = {
              action = move-column-right;
            };
            "Mod+Shift+H" = {
              action = move-column-left;
            };
            "Mod+Shift+J" = {
              action = move-window-down;
            };
            "Mod+Shift+K" = {
              action = move-window-up;
            };
            "Mod+Shift+L" = {
              action = move-column-right;
            };

            "Mod+Home" = {
              action = focus-column-first;
            };
            "Mod+End" = {
              action = focus-column-last;
            };
            "Mod+Ctrl+Home" = {
              action = move-column-to-first;
            };
            "Mod+Ctrl+End" = {
              action = move-column-to-last;
            };

            "Mod+Ctrl+Left" = {
              action = focus-monitor-left;
            };
            "Mod+Ctrl+Down" = {
              action = focus-monitor-down;
            };
            "Mod+Ctrl+Up" = {
              action = focus-monitor-up;
            };
            "Mod+Ctrl+Right" = {
              action = focus-monitor-right;
            };
            "Mod+Ctrl+H" = {
              action = focus-monitor-left;
            };
            "Mod+Ctrl+J" = {
              action = focus-monitor-down;
            };
            "Mod+Ctrl+K" = {
              action = focus-monitor-up;
            };
            "Mod+Ctrl+L" = {
              action = focus-monitor-right;
            };

            "Mod+Shift+Ctrl+Left" = {
              action = move-column-to-monitor-left;
            };
            "Mod+Shift+Ctrl+Down" = {
              action = move-column-to-monitor-down;
            };
            "Mod+Shift+Ctrl+Up" = {
              action = move-column-to-monitor-up;
            };
            "Mod+Shift+Ctrl+Right" = {
              action = move-column-to-monitor-right;
            };
            "Mod+Shift+Ctrl+H" = {
              action = move-column-to-monitor-left;
            };
            "Mod+Shift+Ctrl+J" = {
              action = move-column-to-monitor-down;
            };
            "Mod+Shift+Ctrl+K" = {
              action = move-column-to-monitor-up;
            };
            "Mod+Shift+Ctrl+L" = {
              action = move-column-to-monitor-right;
            };

            "Mod+Page_Down" = {
              action = focus-workspace-down;
            };
            "Mod+Page_Up" = {
              action = focus-workspace-up;
            };
            "Mod+U" = {
              action = focus-workspace-down;
            };
            "Mod+I" = {
              action = focus-workspace-up;
            };
            "Mod+Ctrl+Page_Down" = {
              action = move-column-to-workspace-down;
            };
            "Mod+Ctrl+Page_Up" = {
              action = move-column-to-workspace-up;
            };
            "Mod+Ctrl+U" = {
              action = move-column-to-workspace-down;
            };
            "Mod+Ctrl+I" = {
              action = move-column-to-workspace-up;
            };

            "Mod+Shift+Page_Down" = {
              action = move-workspace-down;
            };
            "Mod+Shift+Page_Up" = {
              action = move-workspace-up;
            };
            "Mod+Shift+U" = {
              action = move-workspace-down;
            };
            "Mod+Shift+I" = {
              action = move-workspace-up;
            };

            "Mod+WheelScrollDown" = {
              action = focus-workspace-down;
              cooldown-ms = 150;
            };
            "Mod+WheelScrollUp" = {
              action = focus-workspace-up;
              cooldown-ms = 150;
            };
            "Mod+Ctrl+WheelScrollDown" = {
              action = move-column-to-workspace-down;
              cooldown-ms = 150;
            };
            "Mod+Ctrl+WheelScrollUp" = {
              action = move-column-to-workspace-up;
              cooldown-ms = 150;
            };

            "Mod+WheelScrollRight" = {
              action = focus-column-right;
            };
            "Mod+WheelScrollLeft" = {
              action = focus-column-left;
            };
            "Mod+Ctrl+WheelScrollRight" = {
              action = move-column-right;
            };
            "Mod+Ctrl+WheelScrollLeft" = {
              action = move-column-left;
            };

            "Mod+Shift+WheelScrollDown" = {
              action = focus-column-right;
            };
            "Mod+Shift+WheelScrollUp" = {
              action = focus-column-left;
            };
            "Mod+Ctrl+Shift+WheelScrollDown" = {
              action = move-column-right;
            };
            "Mod+Ctrl+Shift+WheelScrollUp" = {
              action = move-column-left;
            };

            "Mod+1" = {
              action = focus-workspace 1;
            };
            "Mod+2" = {
              action = focus-workspace 2;
            };
            "Mod+3" = {
              action = focus-workspace 3;
            };
            "Mod+4" = {
              action = focus-workspace 4;
            };
            "Mod+5" = {
              action = focus-workspace 5;
            };
            "Mod+6" = {
              action = focus-workspace 6;
            };
            "Mod+7" = {
              action = focus-workspace 7;
            };
            "Mod+8" = {
              action = focus-workspace 8;
            };
            "Mod+9" = {
              action = focus-workspace 9;
            };

            "Mod+BracketLeft" = {
              action = consume-or-expel-window-left;
            };
            "Mod+BracketRight" = {
              action = consume-or-expel-window-right;
            };

            "Mod+Comma" = {
              action = consume-window-into-column;
            };
            "Mod+Period" = {
              action = expel-window-from-column;
            };

            "Mod+R" = {
              action = switch-preset-column-width;
            };
            "Mod+Shift+R" = {
              action = switch-preset-window-height;
            };
            "Mod+Ctrl+R" = {
              action = reset-window-height;
            };
            "Mod+Shift+F" = {
              action = maximize-column;
            };
            "Mod+F" = {
              action = fullscreen-window;
            };

            "Mod+Ctrl+F" = {
              action = expand-column-to-available-width;
            };

            "Mod+C" = {
              action = center-column;
            };

            "Mod+Ctrl+C" = {
              action = center-visible-columns;
            };

            "Mod+Minus" = {
              action = set-column-width "-10%";
            };
            "Mod+Equal" = {
              action = set-column-width "+10%";
            };

            "Mod+Shift+Minus" = {
              action = set-window-height "-10%";
            };
            "Mod+Shift+Equal" = {
              action = set-window-height "+10%";
            };

            "Mod+V" = {
              action = toggle-window-floating;
            };
            "Mod+Shift+V" = {
              action = switch-focus-between-floating-and-tiling;
            };

            "Mod+T" = {
              action = toggle-column-tabbed-display;
            };

            "Mod+Escape" = {
              action = toggle-keyboard-shortcuts-inhibit;
              allow-inhibiting = false;
            };

            "Mod+Shift+E" = {
              action = quit;
            };
            "Ctrl+Alt+Delete" = {
              action = quit;
            };

            "Mod+Shift+P" = {
              action = power-off-monitors;
            };
          };
        };
      };
    };
}
