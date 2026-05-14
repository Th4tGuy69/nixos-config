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
              "${mod} + q, exec_cmd ${terminal}"
              "${mod} + SHIFT, q, exec_cmd, kitty"
              "${mod} + e, exec_cmd, ${fileManager}"
              "${mod} + space, exec_cmd, ${launcher}"
              "${mod} + SHIFT, s, exec_cmd, ${screenshot}"
              "${mod} + c, exec_cmd, hyprpicker -a"
              "${mod} + w, killactive,"
              "${mod} + f, fullscreen,"
              "${mod} + SHIFT, f, togglefloating,"
              "${mod} + m, exit,"
              "${mod} + p, pseudo,"
              "${mod} + s, layoutmsg, togglesplit"
              "${mod} + left, movefocus, l"
              "${mod} + right, movefocus, r"
              "${mod} + up, movefocus, u"
              "${mod} + down, movefocus, d"
              "${mod} + SHIFT, left, movewindow, l"
              "${mod} + SHIFT, right, movewindow, r"
              "${mod} + SHIFT, up, movewindow, u"
              "${mod} + SHIFT, down, movewindow, d"
              "${mod} + 1, workspace, 1"
              "${mod} + 2, workspace, 2"
              "${mod} + 3, workspace, 3"
              "${mod} + 4, workspace, 4"
              "${mod} + 5, workspace, 5"
              "${mod} + 6, workspace, 6"
              "${mod} + 7, workspace, 7"
              "${mod} + 8, workspace, 8"
              "${mod} + 9, workspace, 9"
              "${mod} + 0, workspace, 10"
              "${mod} + escape, togglespecialworkspace, magic"
              "${mod} + SHIFT, 1, movetoworkspace, 1"
              "${mod} + SHIFT, 2, movetoworkspace, 2"
              "${mod} + SHIFT, 3, movetoworkspace, 3"
              "${mod} + SHIFT, 4, movetoworkspace, 4"
              "${mod} + SHIFT, 5, movetoworkspace, 5"
              "${mod} + SHIFT, 6, movetoworkspace, 6"
              "${mod} + SHIFT, 7, movetoworkspace, 7"
              "${mod} + SHIFT, 8, movetoworkspace, 8"
              "${mod} + SHIFT, 9, movetoworkspace, 9"
              "${mod} + SHIFT, 0, movetoworkspace, 10"
              "${mod} + SHIFT, escape, movetoworkspace, special:magic"
              ", insert, sendshortcut, CTRL SHIFT, d, class:discord"
            ];

          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];

          bindl = [
            ", XF86AudioPlay, exec_cmd, playerctl play-pause"
            ", XF86AudioPrev, exec_cmd, playerctl previous"
            ", XF86AudioNext, exec_cmd, playerctl next"
          ];

          monitor = map monitorConfig config.gui.monitors;
        };
      };
    };
}
