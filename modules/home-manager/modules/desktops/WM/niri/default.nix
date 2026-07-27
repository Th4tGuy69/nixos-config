{ ... }:

{
  flake.homeModules.niri = { ... }: {
    programs.niri.settings = {
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      hotkey-overlay = {
        hide-not-bound = false;
        skip-at-startup = false;
      };

      config-notification.disable-failed = false;
      clipboard.disable-primary = false;
      prefer-no-csd = false;

      spawn-at-startup = [ ];

      # Binds (per bind defaults)
      # binds.<name>.action = null; # required, niri action
      # binds.<name>.allow-inhibiting = true;
      # binds.<name>.allow-when-locked = false;
      # binds.<name>.cooldown-ms = null;
      # binds.<name>.hotkey-overlay = { hidden = false; };
      # binds.<name>.repeat = true;

      switch-events = {
        lid-close = null;
        lid-open = null;
        tablet-mode-off = null;
        tablet-mode-on = null;
      };

      # Workspaces (named workspaces)
      # workspaces.<name>.name = <key>; # defaults to the attribute key
      # workspaces.<name>.open-on-output = null;

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
          repeat-delay = 600;
          repeat-rate = 25;
          track-layout = "global";
          xkb = {
            file = null;
            layout = "";
            model = "";
            options = null;
            rules = "";
            variant = "";
          };
        };

        mod-key = null;
        mod-key-nested = null;

        mouse = {
          accel-profile = null;
          accel-speed = null;
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

      # Outputs (per output defaults)
      # outputs.<name>.backdrop-color = null;
      # outputs.<name>.background-color = null;
      # outputs.<name>.enable = true;
      # outputs.<name>.focus-at-startup = false;
      # outputs.<name>.mode = null;
      # outputs.<name>.mode.refresh = null;
      # outputs.<name>.name = <key>; # defaults to the attribute key
      # outputs.<name>.position = null;
      # outputs.<name>.scale = null;
      # outputs.<name>.transform.flipped = false;
      # outputs.<name>.transform.rotation = 0;
      # outputs.<name>.variable-refresh-rate = false;

      cursor = {
        hide-after-inactive-ms = null;
        hide-when-typing = false;
        size = 24;
        theme = "default";
      };

      layout = {
        background-color = null;
        always-center-single-column = false;
        center-focused-column = "never";
        default-column-display = "normal";
        default-column-width = { };
        empty-workspace-above-first = false;
        gaps = 16;

        border = {
          enable = false;
          width = 4;
          active = null;
          inactive = null;
          urgent = null;
        };

        focus-ring = {
          enable = true;
          width = 4;
          active = null;
          inactive = null;
          urgent = null;
        };

        shadow = {
          color = "#00000070";
          draw-behind-window = false;
          enable = false;
          inactive-color = null;
          offset = {
            x = 0;
            y = 5;
          };
          softness = 30;
          spread = 5;
        };

        insert-hint = {
          enable = true;
          display = null;
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
          custom-shader = null;
          enable = true;
          kind = null;
        };

        window-movement = {
          enable = true;
          kind = null;
        };

        window-open = {
          custom-shader = null;
          enable = true;
          kind = null;
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

      # Window rules (list of rules)
      # window-rules = [];

      # Layer rules (list of rules)
      # layer-rules = [];

      xwayland-satellite = {
        enable = true;
        path = null;
      };

      # debug = {}; # Debug options for niri
    };
  };
}
