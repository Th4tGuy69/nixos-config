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
          "$mod" = "SUPER";

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

          exec-once =
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
            "SUPER, s, layoutmsg, togglesplit"
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

          monitor = map monitorConfig config.gui.monitors;
        };
      };
    };
}
