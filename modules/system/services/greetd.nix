{ ... }:

{
  flake.nixosModules.greetd =
    { pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session.command = "${pkgs.hyprland}/bin/start-hyprland -- --config /etc/greetd/hyprland.conf";
        };
      };

      environment.etc."greetd/hyprland.conf".text = ''
        exec-once = ${pkgs.regreet}/bin/regreet; hyprctl dispatch exit

        animations {
          enabled = false
        }

        misc {
            disable_hyprland_logo = true
            disable_splash_rendering = true
        }
      '';
    };
}
