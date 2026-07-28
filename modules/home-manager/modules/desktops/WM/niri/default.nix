{ ... }:

{
  flake.homeModules.niri = { config, ... }: {
    programs.niri.settings = {
      screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png";

      hotkey-overlay = {
        hide-not-bound = false;
        skip-at-startup = true;
      };

      config-notification.disable-failed = false;
      clipboard.disable-primary = false;
      prefer-no-csd = true;

      spawn-at-startup = map (app: { command = [ app ]; }) config.gui.startupApps;

      binds = {
        "Mod+Shift+Slash".action = {
          show-hotkey-overlay = { };
        };

        "Mod+Q".action.spawn = [ config.gui.terminal ];
        "Mod+Space".action.spawn = [ config.gui.runner ];
        "Super+Alt+L".action.spawn = [ "swaylock" ];

        "Mod+W".action = {
          close-window = { };
        };

        "Mod+Left".action = {
          focus-column-left = { };
        };
        "Mod+Down".action = {
          focus-window-down = { };
        };
        "Mod+Up".action = {
          focus-window-up = { };
        };
        "Mod+Right".action = {
          focus-column-right = { };
        };

        "Mod+Ctrl+Left".action = {
          move-column-left = { };
        };
        "Mod+Ctrl+Down".action = {
          move-window-down = { };
        };
        "Mod+Ctrl+Up".action = {
          move-window-up = { };
        };
        "Mod+Ctrl+Right".action = {
          move-column-right = { };
        };

        "Mod+Home".action = {
          focus-column-first = { };
        };
        "Mod+End".action = {
          focus-column-last = { };
        };
        "Mod+Ctrl+Home".action = {
          move-column-to-first = { };
        };
        "Mod+Ctrl+End".action = {
          move-column-to-last = { };
        };

        "Mod+Shift+Left".action = {
          focus-monitor-left = { };
        };
        "Mod+Shift+Down".action = {
          focus-monitor-down = { };
        };
        "Mod+Shift+Up".action = {
          focus-monitor-up = { };
        };
        "Mod+Shift+Right".action = {
          focus-monitor-right = { };
        };

        "Mod+Shift+Ctrl+Left".action = {
          move-column-to-monitor-left = { };
        };
        "Mod+Shift+Ctrl+Down".action = {
          move-column-to-monitor-down = { };
        };
        "Mod+Shift+Ctrl+Up".action = {
          move-column-to-monitor-up = { };
        };
        "Mod+Shift+Ctrl+Right".action = {
          move-column-to-monitor-right = { };
        };

        "Mod+Page_Down".action = {
          focus-workspace-down = { };
        };
        "Mod+Page_Up".action = {
          focus-workspace-up = { };
        };
        "Mod+U".action = {
          focus-workspace-down = { };
        };
        "Mod+I".action = {
          focus-workspace-up = { };
        };

        "Mod+Ctrl+Page_Down".action = {
          move-column-to-workspace-down = { };
        };
        "Mod+Ctrl+Page_Up".action = {
          move-column-to-workspace-up = { };
        };
        "Mod+Ctrl+U".action = {
          move-column-to-workspace-down = { };
        };
        "Mod+Ctrl+I".action = {
          move-column-to-workspace-up = { };
        };

        "Mod+Shift+Page_Down".action = {
          move-workspace-down = { };
        };
        "Mod+Shift+Page_Up".action = {
          move-workspace-up = { };
        };
        "Mod+Shift+U".action = {
          move-workspace-down = { };
        };
        "Mod+Shift+I".action = {
          move-workspace-up = { };
        };

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+Comma".action = {
          consume-window-into-column = { };
        };
        "Mod+Period".action = {
          expel-window-from-column = { };
        };

        "Mod+R".action = {
          switch-preset-column-width = { };
        };
        "Mod+F".action = {
          fullscreen-window = { };
        };
        "Mod+Shift+F".action = {
          toggle-window-floating = { };
        };
        "Mod+C".action = {
          center-column = { };
        };
        "Mod+Ctrl+C".action = {
          center-visible-columns = { };
        };

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";

        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Print".action = {
          screenshot = { };
        };
        "Ctrl+Print".action = {
          screenshot-screen = { };
        };
        "Alt+Print".action = {
          screenshot-window = { };
        };

        "Mod+Shift+E".action = {
          quit = { };
        };
        "Mod+Shift+P".action = {
          power-off-monitors = { };
        };
      };

      switch-events = {
        lid-close = null;
        lid-open = null;
        tablet-mode-off = null;
        tablet-mode-on = null;
      };

      overview = {
        backdrop-color = null;
        workspace-shadow = {
          color = null;
          enable = true;
          offset = null;
          # offset.x = 0;
          # offset.y = 5;
          softness = null;
          spread = null;
        };
        zoom = null;
      };

      input = {
        focus-follows-mouse = {
          enable = false;
          max-scroll-amount = null;
        };

        keyboard = {
          numlock = false;
          repeat-delay = 200;
          repeat-rate = 35;
          track-layout = "global";
          xkb = {
            file = null;
            layout = "us";
            model = "";
            options = null;
            rules = "";
            variant = "";
          };
        };

        mod-key = null;
        mod-key-nested = null;

        mouse = {
          accel-profile = "flat";
          accel-speed = -0.5;
          enable = true;
          left-handed = false;
          middle-emulation = false;
          natural-scroll = false;
          scroll-button = null;
          scroll-button-lock = false;
          scroll-factor = null;
          scroll-method = null;
        };

        power-key-handling.enable = true;

        tablet = {
          calibration-matrix = null;
          enable = true;
          left-handed = false;
          map-to-output = null;
        };

        touch = {
          enable = true;
          map-to-output = null;
        };

        touchpad = {
          accel-profile = null;
          accel-speed = null;
          click-method = null;
          disabled-on-external-mouse = false;
          drag = null;
          drag-lock = false;
          dwt = false;
          dwtp = false;
          enable = true;
          left-handed = false;
          middle-emulation = false;
          natural-scroll = true;
          scroll-button = null;
          scroll-button-lock = false;
          scroll-factor = null;
          scroll-method = null;
          tap = true;
          tap-button-map = null;
        };

        trackball = {
          accel-profile = null;
          accel-speed = null;
          enable = true;
          left-handed = false;
          middle-emulation = false;
          natural-scroll = false;
          scroll-button = null;
          scroll-button-lock = false;
          scroll-method = null;
        };

        trackpoint = {
          accel-profile = null;
          accel-speed = null;
          enable = true;
          left-handed = false;
          middle-emulation = false;
          natural-scroll = false;
          scroll-button = null;
          scroll-button-lock = false;
          scroll-method = null;
        };

        warp-mouse-to-focus = {
          enable = false;
          mode = null;
        };

        workspace-auto-back-and-forth = false;
      };

      outputs = {
        "DP-1" = {
          enable = true;
          focus-at-startup = true;
          mode = null; # preferred
          position = {
            x = 0;
            y = 0;
          };
          scale = 1;
          transform.rotation = 0;
        };

        "LG Electronics 27GL650F 008NTHM5V961" = {
          enable = true;
          mode = null; # preferred
          position = {
            x = -1080;
            y = -56;
          };
          scale = 1;
          transform.rotation = 90;
        };

        "Hisense Electric Co. Ltd. HISENSE 0x00000001" = {
          enable = true;
          mode = {
            width = 3840;
            height = 2160;
            refresh = 60.0;
          };
          position = {
            x = 0;
            y = 0;
          };
          scale = 2;
          transform.rotation = 0;
        };
      };

      cursor = {
        hide-after-inactive-ms = null;
        hide-when-typing = false;
        size = 24;
        theme = "default";
      };

      layout = {
        background-color = "black";
        always-center-single-column = true;
        center-focused-column = "never";
        default-column-display = "normal";
        default-column-width = {
          proportion = 0.5;
        };
        empty-workspace-above-first = false;
        gaps = 16;

        border.enable = false;

        focus-ring = {
          enable = true;
          width = 1;
          active = {
            color = "#ffffff";
          };
        };

        insert-hint = {
          enable = true;
          display = {
            color = "#ffffff80";
          };
        };

        struts = {
          bottom = 0;
          left = 0;
          right = 0;
          top = 0;
        };

        tab-indicator = null;
        # tab-indicator = {
        #   corner-radius = 0;
        #   enable = true;
        #   gap = 5;
        #   gaps-between-tabs = 0;
        #   hide-when-single-tab = false;
        #   length.total-proportion = 0.5;
        #   place-within-column = false;
        #   position = "left";
        #   width = 4;
        #   active = null;
        #   inactive = null;
        #   urgent = null;
        # };
      };

      animations = {
        enable = true;
        slowdown = null;

        config-notification-open-close = {
          enable = true;
          kind = null;
        };

        exit-confirmation-open-close = {
          enable = true;
          kind = null;
        };

        horizontal-view-movement = {
          enable = true;
          kind = null;
        };

        overview-open-close = {
          enable = true;
          kind = null;
        };

        screenshot-ui-open = {
          enable = true;
          kind = null;
        };

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
          enable = true;
          kind.easing = {
            duration-ms = 500;
            curve = "ease-out-cubic";
          };
        };

        window-movement = {
          enable = true;
          kind = null;
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
          enable = true;

          kind.easing = {
            duration-ms = 500;
            curve = "ease-out-cubic";
          };
        };

        window-resize = {
          custom-shader = null;
          enable = true;
          kind = null;
        };

        workspace-switch = {
          enable = true;
          kind = null;
        };
      };

      gestures = {
        dnd-edge-view-scroll = {
          delay-ms = null;
          max-speed = null;
          trigger-width = null;
        };

        dnd-edge-workspace-switch = {
          delay-ms = null;
          max-speed = null;
          trigger-height = null;
        };

        hot-corners.enable = true;
      };

      environment = { };

      window-rules = [
        {
          matches = [ ];
          excludes = [ ];

          geometry-corner-radius = {
            bottom-left = 10.0;
            bottom-right = 10.0;
            top-left = 10.0;
            top-right = 10.0;
          };
          clip-to-geometry = true;
        }
      ];

      layer-rules = [ ];

      xwayland-satellite = {
        enable = true;
        path = null;
      };
    };
  };
}
