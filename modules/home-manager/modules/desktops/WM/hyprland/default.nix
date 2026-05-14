{ self, lib, ... }:

{
  flake.homeModules.hyprland =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    let
      screenshot = "grimblast copy area";

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

      terminal = config.gui.terminal;
      fileManager = config.gui.fileManager;
      launcher = config.gui.runner;

      monitorConfig =
        m:
        let
          # Determine monitor identifier
          identifier =
            if m.wildcard or false then
              ", preferred, auto, 1"
            else if m ? description && m.description != null then
              "desc:${m.description}"
            else
              m.name;

          # Determine resolution/refresh rate
          resolution =
            if m.preferred or false then
              "preferred"
            else if m ? width && m ? height then
              "${toString m.width}x${toString m.height}"
              + (if m ? refreshRate then "@${toString m.refreshRate}" else "")
            else
              "auto";

          # Position
          position = "${toString (m.x or 0)}x${toString (m.y or 0)}";

          # Scale
          scale = toString (m.scale or 1);

          # Transform
          transform =
            if m ? transform && m.transform != null then ", transform, ${toString (m.transform / 90)}" else "";
        in
        "${identifier}, ${resolution}, ${position}, ${scale}${transform}";
    in
    {
      imports = [ self.homeModules.hyprsunset ];

      home.packages = with pkgs; [
        hyprnotify
        hyprpolkitagent
        hyprpicker
        wl-clipboard
        grimblast
        kitty
        clock-rs
      ];

      services.hypridle.enable = config.gui.windowManager == "hyprland";
      programs.hyprlock.enable = config.gui.windowManager == "hyprland";

      wayland.windowManager.hyprland = lib.mkIf (config.gui.windowManager == "hyprland") {
        enable = true;
        package = inputs.hyprland.packages.x86_64-linux.hyprland;
        portalPackage = inputs.hyprland.packages.x86_64-linux.xdg-desktop-portal-hyprland;

        settings = {
          ecosystem.no_update_news = true;

          general = {
            "gaps_in" = gapsIn;
            "gaps_out" = gapsOut;
            "border_size" = borderSize;
            "resize_on_border" = false;
            "allow_tearing" = true;
            "layout" = "dwindle";
          };

          decoration = {
            rounding = rounding;
            active_opacity = activeOpacity;
            inactive_opacity = inactiveOpacity;
            shadow = {
              enabled = shadowEnabled;
              range = 4;
              render_power = 3;
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
            middle_click_paste = false;
            vrr = 3;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };

          cursor = {
            hide_on_key_press = true;
            no_hardware_cursors = 1;
          };

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

          exec_cmd =
            let
              lat = config.sops.secrets.latitude.path;
              lon = config.sops.secrets.longitude.path;
            in
            config.gui.startupApps
            ++ [
              "systemctl --user start hyprpolkitagent"
              "systemctl --user enable --now hyprsunset.service"
              ''
                sleep 5s;
                nerdshade \
                -loop \
                -gammaNight 75 \
                -latitude $(cat ${lat}) \
                -longitude $(cat ${lon}) \
                -tempNight 1600
              ''
            ];

          windowrule = [
            "match:class .*, suppress_event maximize"
            "match:class ^$; title:^$; xwayland:1; floating:1; fullscreen:0; pinned:0, no_focus true"
            "match:class zen-beta, monitor DP-1"
            "match:class goofcord, monitor HDMI-A-1"
            "match:class discord, monitor HDMI-A-1"
            "match:class Spotify, monitor HDMI-A-1"
            "match:float true, border_color rgba(FFFFFF99) rgba(FFFFFF33)"
            "match:float true, border_size 2"
            "match:class xdg-desktop-portal-gtk, float true"
            "match:class org.prismlauncher.PrismLauncher, float true"
            "match:class tofi-drun, no_anim true"
            "match:class qalculate-gtk, float true"
            "match:title QEMU, fullscreen true"
            "match:title UnityEditor.Searcher.SearcherWindow, allows_input true"
            "match:title Color, move cursor -50% -5%"
            "match:title Project Settings, center true"
            "match:title Android Emulator, size 479 1038"
            "match:title Android Emulator, max_size 472 1038"
            "match:title Android Emulator, min_size 472 1038"
            "match:class dev.zed.Zed, render_unfocused true"
            "match:title Steam Big Picture Mode, max_size 1920 1080"
            "match:title Steam Big Picture Mode, min_size 1920 1080"
            "match:title Steam Big Picture Mode, float true"
            "match:title Steam Big Picture Mode, fullscreen_state 3 -1"
            "match:class (steam_app).*, immediate true"
            "match:class steam_app_2622380, render_unfocused true"
            "match:class steam_app_2622380, fullscreen_state -1 3"
            "match:class cs2, immediate true"
            "match:class tf_linux64, immediate true"
            "match:class Minecraft, immediate true"
          ];

          bind =
            let
              mod = "SUPER";
            in
            with lib.generators;
            [
              {
                _args = [
                  "${mod} + Q"
                  (mkLuaInline "hl.dsp.exec_cmd(${terminal})")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + Q"
                  (mkLuaInline "hl.dsp.exec_cmd(kitty)")
                ];
              }
              {
                _args = [
                  "${mod} + E"
                  (mkLuaInline "hl.dsp.exec_cmd(${fileManager})")
                ];
              }
              {
                _args = [
                  "${mod} + SPACE"
                  (mkLuaInline "hl.dsp.exec_cmd(${launcher})")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + S"
                  (mkLuaInline "hl.dsp.exec_cmd(${screenshot})")
                ];
              }
              {
                _args = [
                  "${mod} + C"
                  (mkLuaInline "hl.dsp.exec_cmd(\"hyprpicker -a\")")
                ];
              }
              {
                _args = [
                  "${mod} + W"
                  (mkLuaInline "hl.dsp.window.close()")
                ];
              }
              {
                _args = [
                  "${mod} + F"
                  (mkLuaInline "hl.dsp.window.fullscreen()")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + F"
                  (mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
                ];
              }
              {
                _args = [
                  "${mod} + M"
                  (mkLuaInline "hl.dsp.exit()")
                ];
              }
              {
                _args = [
                  "${mod} + P"
                  (mkLuaInline "hl.dsp.window.pseudo()")
                ];
              }
              {
                _args = [
                  "${mod} + S"
                  (mkLuaInline "hl.dsp.layout(\"togglesplit\")")
                ];
              }
              {
                _args = [
                  "${mod} + left"
                  (mkLuaInline "hl.dsp.focus({ direction = \"left\" })")
                ];
              }
              {
                _args = [
                  "${mod} + right"
                  (mkLuaInline "hl.dsp.focus({ direction = \"right\" })")
                ];
              }
              {
                _args = [
                  "${mod} + up"
                  (mkLuaInline "hl.dsp.focus({ direction = \"up\" })")
                ];
              }
              {
                _args = [
                  "${mod} + down"
                  (mkLuaInline "hl.dsp.focus({ direction = \"down\" })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + left"
                  (mkLuaInline "hl.dsp.window.move({ direction = \"left\" })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + right"
                  (mkLuaInline "hl.dsp.window.move({ direction = \"right\" })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + up"
                  (mkLuaInline "hl.dsp.window.move({ direction = \"up\" })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + down"
                  (mkLuaInline "hl.dsp.window.move({ direction = \"down\" })")
                ];
              }
              {
                _args = [
                  "${mod} + 1"
                  (mkLuaInline "hl.dsp.focus({ workspace = 1 })")
                ];
              }
              {
                _args = [
                  "${mod} + 2"
                  (mkLuaInline "hl.dsp.focus({ workspace = 2 })")
                ];
              }
              {
                _args = [
                  "${mod} + 3"
                  (mkLuaInline "hl.dsp.focus({ workspace = 3 })")
                ];
              }
              {
                _args = [
                  "${mod} + 4"
                  (mkLuaInline "hl.dsp.focus({ workspace = 4 })")
                ];
              }
              {
                _args = [
                  "${mod} + 5"
                  (mkLuaInline "hl.dsp.focus({ workspace = 5 })")
                ];
              }
              {
                _args = [
                  "${mod} + 6"
                  (mkLuaInline "hl.dsp.focus({ workspace = 6 })")
                ];
              }
              {
                _args = [
                  "${mod} + 7"
                  (mkLuaInline "hl.dsp.focus({ workspace = 7 })")
                ];
              }
              {
                _args = [
                  "${mod} + 8"
                  (mkLuaInline "hl.dsp.focus({ workspace = 8 })")
                ];
              }
              {
                _args = [
                  "${mod} + 9"
                  (mkLuaInline "hl.dsp.focus({ workspace = 9 })")
                ];
              }
              {
                _args = [
                  "${mod} + 0"
                  (mkLuaInline "hl.dsp.focus({ workspace = 10 })")
                ];
              }
              {
                _args = [
                  "${mod} + escape"
                  (mkLuaInline "hl.dsp.workspace.toggle_special(\"magic\")")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 1"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 1 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 2"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 2 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 3"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 3 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 4"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 4 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 5"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 5 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 6"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 6 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 7"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 7 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 8"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 8 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 9"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 9 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + 0"
                  (mkLuaInline "hl.dsp.window.move({ workspace = 10 })")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + escape"
                  (mkLuaInline "hl.dsp.window.move({ workspace = \"special:magic\" })")
                ];
              }
              {
                _args = [
                  "insert"
                  (mkLuaInline "hl.dsp.sendshortcut(\"CTRL SHIFT\", \"d\", { class = \"discord\" })")
                ];
              }
            ];

          monitor = map monitorConfig config.gui.monitors;
        };
      };
    };
}
