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
            [
              "${mod} + q, hl.dsp.exec_cmd(\"${terminal}\")"
              "${mod} + SHIFT + q, hl.dsp.exec_cmd(\"kitty\")"
              "${mod} + e, hl.dsp.exec_cmd(\"${fileManager}\")"
              "${mod} + space, hl.dsp.exec_cmd(\"${launcher}\")"
              "${mod} + SHIFT + s, hl.dsp.exec_cmd(\"${screenshot}\")"
              "${mod} + c, hl.dsp.exec_cmd(\"hyprpicker -a\")"
              "${mod} + w, hl.dsp.window.close()"
              "${mod} + f, hl.dsp.window.fullscreen()"
              "${mod} + SHIFT + f, hl.dsp.window.float({ action = \"toggle\" })"
              "${mod} + m, hl.dsp.exit()"
              "${mod} + p, hl.dsp.window.pseudo()"
              "${mod} + s, hl.dsp.layout(\"togglesplit\")"
              "${mod} + left, hl.dsp.focus({ direction = \"left\" })"
              "${mod} + right, hl.dsp.focus({ direction = \"right\" })"
              "${mod} + up, hl.dsp.focus({ direction = \"up\" })"
              "${mod} + down, hl.dsp.focus({ direction = \"down\" })"
              "${mod} + SHIFT + left, hl.dsp.window.move({ direction = \"left\" })"
              "${mod} + SHIFT + right, hl.dsp.window.move({ direction = \"right\" })"
              "${mod} + SHIFT + up, hl.dsp.window.move({ direction = \"up\" })"
              "${mod} + SHIFT + down, hl.dsp.window.move({ direction = \"down\" })"
              "${mod} + 1, hl.dsp.focus({ workspace = 1 })"
              "${mod} + 2, hl.dsp.focus({ workspace = 2 })"
              "${mod} + 3, hl.dsp.focus({ workspace = 3 })"
              "${mod} + 4, hl.dsp.focus({ workspace = 4 })"
              "${mod} + 5, hl.dsp.focus({ workspace = 5 })"
              "${mod} + 6, hl.dsp.focus({ workspace = 6 })"
              "${mod} + 7, hl.dsp.focus({ workspace = 7 })"
              "${mod} + 8, hl.dsp.focus({ workspace = 8 })"
              "${mod} + 9, hl.dsp.focus({ workspace = 9 })"
              "${mod} + 0, hl.dsp.focus({ workspace = 10 })"
              "${mod} + escape, hl.dsp.workspace.toggle_special(\"magic\")"
              "${mod} + SHIFT + 1, hl.dsp.window.move({ workspace = 1 })"
              "${mod} + SHIFT + 2, hl.dsp.window.move({ workspace = 2 })"
              "${mod} + SHIFT + 3, hl.dsp.window.move({ workspace = 3 })"
              "${mod} + SHIFT + 4, hl.dsp.window.move({ workspace = 4 })"
              "${mod} + SHIFT + 5, hl.dsp.window.move({ workspace = 5 })"
              "${mod} + SHIFT + 6, hl.dsp.window.move({ workspace = 6 })"
              "${mod} + SHIFT + 7, hl.dsp.window.move({ workspace = 7 })"
              "${mod} + SHIFT + 8, hl.dsp.window.move({ workspace = 8 })"
              "${mod} + SHIFT + 9, hl.dsp.window.move({ workspace = 9 })"
              "${mod} + SHIFT + 0, hl.dsp.window.move({ workspace = 10 })"
              "${mod} + SHIFT + escape, hl.dsp.window.move({ workspace = \"special:magic\" })"
              ", insert, hl.dsp.sendshortcut(\"CTRL SHIFT\", \"d\", { class = \"discord\" })"
            ];

          monitor = map monitorConfig config.gui.monitors;
        };
      };
    };
}
