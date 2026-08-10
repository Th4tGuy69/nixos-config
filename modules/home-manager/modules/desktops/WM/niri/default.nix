{
  ...
}:

{
  flake.homeModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      wayland.windowManager.niri = {
        enable = true;

        settings = {
          hotkey-overlay = {
            skip-at-startup = { };
          };

          config-notification.disable-failed = false;
          clipboard.disable-primary = false;
          prefer-no-csd = { };

          _children =
            (map (app: {
              spawn-at-startup._args = [ app ];
            }) config.gui.startupApps)
            ++ [
              {
                output = {
                  _args = [ "DP-1" ];
                  focus-at-startup = { };
                  position._props = {
                    x = 0;
                    y = 0;
                  };
                  scale = 1;
                  transform = "normal";
                };
              }

              {
                output = {
                  _args = [ "LG Electronics 27GL650F 008NTHM5V961" ];
                  position._props = {
                    x = -1080;
                    y = -56;
                  };
                  scale = 1;
                  transform = "90";
                };
              }

              {
                output = {
                  _args = [ "Hisense Electric Co. Ltd. HISENSE 0x00000001" ];
                  mode._args = [ "3840x2160@60.0" ];
                  position._props = {
                    x = 0;
                    y = 0;
                  };
                  scale = 2;
                  transform = "normal";
                };
              }

              {
                window-rule = {
                  clip-to-geometry = true;
                  geometry-corner-radius = 10.0;
                };
              }
            ];

          binds = {
            "Mod+Shift+Slash".show-hotkey-overlay = { };

            "Mod+Q".spawn = [ config.gui.terminal ];
            "Mod+Space".spawn = [ config.gui.runner ];
            "Super+Alt+L".spawn = [ "swaylock" ];

            "Mod+W".close-window = { };

            "Mod+Left".focus-column-left = { };
            "Mod+Down".focus-window-down = { };
            "Mod+Up".focus-window-up = { };
            "Mod+Right".focus-column-right = { };

            "Mod+Ctrl+Left".move-column-left = { };
            "Mod+Ctrl+Down".move-window-down = { };
            "Mod+Ctrl+Up".move-window-up = { };
            "Mod+Ctrl+Right".move-column-right = { };

            "Mod+Home".focus-column-first = { };
            "Mod+End".focus-column-last = { };
            "Mod+Ctrl+Home".move-column-to-first = { };
            "Mod+Ctrl+End".move-column-to-last = { };

            "Mod+Shift+Left".focus-monitor-left = { };
            "Mod+Shift+Down".focus-monitor-down = { };
            "Mod+Shift+Up".focus-monitor-up = { };
            "Mod+Shift+Right".focus-monitor-right = { };

            "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
            "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
            "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
            "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };

            "Mod+Page_Down".focus-workspace-down = { };
            "Mod+Page_Up".focus-workspace-up = { };
            "Mod+U".focus-workspace-down = { };
            "Mod+I".focus-workspace-up = { };

            "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
            "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
            "Mod+Ctrl+U".move-column-to-workspace-down = { };
            "Mod+Ctrl+I".move-column-to-workspace-up = { };

            "Mod+Shift+Page_Down".move-workspace-down = { };
            "Mod+Shift+Page_Up".move-workspace-up = { };
            "Mod+Shift+U".move-workspace-down = { };
            "Mod+Shift+I".move-workspace-up = { };

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;

            "Mod+Ctrl+1".move-column-to-workspace = 1;
            "Mod+Ctrl+2".move-column-to-workspace = 2;
            "Mod+Ctrl+3".move-column-to-workspace = 3;
            "Mod+Ctrl+4".move-column-to-workspace = 4;
            "Mod+Ctrl+5".move-column-to-workspace = 5;
            "Mod+Ctrl+6".move-column-to-workspace = 6;
            "Mod+Ctrl+7".move-column-to-workspace = 7;
            "Mod+Ctrl+8".move-column-to-workspace = 8;
            "Mod+Ctrl+9".move-column-to-workspace = 9;

            "Mod+Comma".consume-window-into-column = { };
            "Mod+Period".expel-window-from-column = { };

            "Mod+R".switch-preset-column-width = { };
            "Mod+F".fullscreen-window = { };
            "Mod+Shift+F".toggle-window-floating = { };
            "Mod+C".center-column = { };
            "Mod+Ctrl+C".center-visible-columns = { };

            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";

            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            "Print".screenshot = { };
            "Ctrl+Print".screenshot-screen = { };
            "Alt+Print".screenshot-window = { };

            "Mod+Shift+E".quit = { };
            "Mod+Shift+P".power-off-monitors = { };
          };

          input = {
            focus-follows-mouse = {
              _props = {
                max-scroll-amount = "0%";
              };
            };

            keyboard = {
              numlock = false;
              repeat-delay = 200;
              repeat-rate = 35;
              xkb.layout = "us";
            };

            mouse = {
              accel-profile = "flat";
              accel-speed = -0.5;
            };
          };

          cursor.hide-when-typing = false;

          layout = {
            background-color = "black";
            always-center-single-column = { };
            center-focused-column = "never";
            default-column-display = "normal";

            default-column-width = {
              proportion = 0.5;
            };

            empty-workspace-above-first = { };
            gaps = 16;

            border = {
              off = { };
            };

            focus-ring = {
              width = 1;
              active-color = "#ffffff";
            };

            insert-hint = {
              color = "#ffffff80";
            };

            struts = {
              left = 0;
              right = 0;
              top = 0;
              bottom = 0;
            };
          };

          animations = {
            window-close = {
              custom-shader = ''
                r"
                vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                    float p = niri_clamped_progress;
                    vec2 uv = coords_geo.xy;

                    vec2 center = vec2(0.5, 0.5);
                    float scale = mix(1.0, 0.95, p);
                    vec2 scaled_uv = (uv - center) / scale + center;

                    vec3 tex_coords = niri_geo_to_tex * vec3(scaled_uv, 1.0);
                    vec4 color = texture2D(niri_tex, tex_coords.st);

                    float alpha = smoothstep(1.0, 0.2, p);

                    return color * alpha;
                }"
              '';

              duration-ms = 500;
              curve = "ease-out-cubic";
            };

            window-open = {
              custom-shader = ''
                r"
                vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                  float p = niri_clamped_progress;
                  vec2 uv = coords_geo.xy;

                  vec2 center = vec2(0.5, 0.5);
                  float scale = mix(0.95, 1.0, p);
                  vec2 scaled_uv = (uv - center) / scale + center;

                  vec3 tex_coords = niri_geo_to_tex * vec3(scaled_uv, 1.0);
                  vec4 color = texture2D(niri_tex, tex_coords.st);

                  float alpha = smoothstep(0.0, 0.8, p);

                  return color * alpha;
                }"
              '';

              duration-ms = 500;
              curve = "ease-out-cubic";
            };
          };
        };
      };
    };
}
