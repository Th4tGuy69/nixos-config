{ inputs, ... }:

{
  flake.homeModules.ironbar =
    { pkgs, ... }:
    let
      frameworkSvg = pkgs.fetchurl {
        name = "framework.svg";
        url = "https://cdn.simpleicons.org/framework/ffffff";
        hash = "sha256-JolkYApM7VjJgHWfQM4uzBmixQ6lFpjq0aFTom76uvY=";
      };
    in
    {
      imports = [ inputs.ironbar.homeManagerModules.default ];

      programs.ironbar = {
        enable = true;

        config = {
          monitors.eDP-1 = {
            position = "bottom";
            height = 24;
            anchor_to_edges = false;
            exclusive_zone = false;

            start = [
              {
                type = "clock";
                name = "clock";
                format = "%-I:%M";
                disable_popup = true;
              }
            ];

            center = [
              {
                type = "custom";
                bar = [
                  {
                    type = "image";
                    src = "${frameworkSvg}";
                    size = 10;
                  }
                ];
              }
            ];

            end = [
              {
                type = "battery";
                name = "battery";
                format = "{percentage}%";
                show_icon = false;
                show_label = true;
                disable_popup = true;
              }
            ];

            margin.bottom = 4;
          };
        };

        style = ''
          * {
            font-family: "Fira Code";
            font-size: 14px;
            font-weight: bold;
            min-height: 0;
            border: none;
            box-shadow: none;
            outline: none;
            text-shadow: none;
            transition: none;
          }

          window {
            background: transparent;
          }

          .background {
            background: rgba(0, 0, 0, 0.5);
            border-radius: 999px;
            padding: 0 8px;
            margin: 0;
          }

          #clock,
          #battery,
          #clock *,
          #battery * {
            background: transparent;
            box-shadow: none;
            outline: none;
            border: none;
          }

          #clock:hover,
          #clock:active,
          #clock:focus,
          #clock:checked,
          #battery:hover,
          #battery:active,
          #battery:focus,
          #battery:checked,
          #clock *:hover,
          #clock *:active,
          #clock *:focus,
          #battery *:hover,
          #battery *:active,
          #battery *:focus {
            background: transparent;
            box-shadow: none;
            outline: none;
            border: none;
          }

          #clock,
          #battery {
            color: #e6e8eb;
            padding: 0 12px;
          }

          #battery.charging {
            color: #1793d1;
          }

          #battery.warning {
            color: #e5a550;
          }

          #battery.critical {
            color: #e05b5b;
          }
        '';
      };
    };
}
