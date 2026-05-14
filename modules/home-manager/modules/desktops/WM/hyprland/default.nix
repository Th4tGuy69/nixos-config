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
          config = {
            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
            };

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

            monitor = map monitorConfig config.gui.monitors;
          };

          on = [
            {
              _args = [
                "hyprland.start"
                (lib.generators.mkLuaInline "function()\n  hl.exec_cmd(\"systemctl --user start hyprpolkitagent\")\nend")
              ];
            }
            {
              _args = [
                "hyprland.start"
                (lib.generators.mkLuaInline "function()\n  hl.exec_cmd(\"systemctl --user enable --now hyprsunset.service\")\nend")
              ];
            }
            {
              _args =
                let
                  lat = config.sops.secrets.latitude.path;
                  lon = config.sops.secrets.longitude.path;
                in
                [
                  "hyprland.start"
                  (lib.generators.mkLuaInline ''
                    function()
                      hl.exec_cmd("sleep 5s; nerdshade -loop -gammaNight 75 -latitude $(cat ${lat}) -longitude $(cat ${lon}) -tempNight 1600")
                    end
                  '')
                ];
            }
          ]
          ++ map (app: {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline "function()\n  hl.exec_cmd(\"${app}\")\nend")
            ];
          }) config.gui.startupApps;

          windowrule = [
            {
              _args = [
                {
                  name = "suppress-maximize-events";
                  match = {
                    class = ".*";
                  };
                  suppress_event = "maximize";
                }
              ];
            }
            {
              _args = [
                {
                  name = "fix-xwayland-drags";
                  match = {
                    class = "^$";
                    title = "^$";
                    xwayland = true;
                    float = true;
                    fullscreen = false;
                    pin = false;
                  };

                  no_focus = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "zen-beta";
                  };
                  monitor = "DP-1";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "goofcord";
                  };
                  monitor = "HDMI-A-1";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "discord";
                  };
                  monitor = "HDMI-A-1";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "Spotify";
                  };
                  monitor = "HDMI-A-1";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    floating = true;
                  };
                  border_color = "rgba(FFFFFF99) rgba(FFFFFF33)";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    floating = true;
                  };
                  border_size = 2;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "xdg-desktop-portal-gtk";
                  };
                  float = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "org.prismlauncher.PrismLauncher";
                  };
                  float = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "tofi-drun";
                  };
                  no_anim = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "qalculate-gtk";
                  };
                  float = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "QEMU";
                  };
                  fullscreen = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "UnityEditor.Searcher.SearcherWindow";
                  };
                  allows_input = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Color";
                  };
                  move = "cursor -50% -5%";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Project Settings";
                  };
                  center = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Android Emulator";
                  };
                  size = "479 1038";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Android Emulator";
                  };
                  max_size = "472 1038";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Android Emulator";
                  };
                  min_size = "472 1038";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "dev.zed.Zed";
                  };
                  render_unfocused = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Steam Big Picture Mode";
                  };
                  max_size = "1920 1080";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Steam Big Picture Mode";
                  };
                  min_size = "1920 1080";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Steam Big Picture Mode";
                  };
                  float = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    title = "Steam Big Picture Mode";
                  };
                  fullscreen_state = "3 -1";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "(steam_app).*";
                  };
                  immediate = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "steam_app_2622380";
                  };
                  render_unfocused = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "steam_app_2622380";
                  };
                  fullscreen_state = "-1 3";
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "cs2";
                  };
                  immediate = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "tf_linux64";
                  };
                  immediate = true;
                }
              ];
            }
            {
              _args = [
                {
                  match = {
                    class = "Minecraft";
                  };
                  immediate = true;
                }
              ];
            }
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
                  (mkLuaInline "hl.dsp.exec_cmd(\"${terminal}\")")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + Q"
                  (mkLuaInline "hl.dsp.exec_cmd(\"kitty\")")
                ];
              }
              {
                _args = [
                  "${mod} + E"
                  (mkLuaInline "hl.dsp.exec_cmd(\"${fileManager}\")")
                ];
              }
              {
                _args = [
                  "${mod} + SPACE"
                  (mkLuaInline "hl.dsp.exec_cmd(\"${launcher}\")")
                ];
              }
              {
                _args = [
                  "${mod} + SHIFT + S"
                  (mkLuaInline "hl.dsp.exec_cmd(\"${screenshot}\")")
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
            ];
        };
      };
    };
}
