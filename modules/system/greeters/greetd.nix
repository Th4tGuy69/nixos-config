{ inputs, ... }:

{
  flake.nixosModules.greetd =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    lib.mkIf config.greeter.greetd.enable {
      services.greetd = {
        enable = true;
        settings.default_session.command = "${
          inputs.scroll-flake.packages.${pkgs.system}.scroll-stable
        }/bin/scroll --config /etc/greetd/scroll.conf";
      };

      environment.etc."greetd/scroll.conf".text = ''
        exec "${pkgs.regreet}/bin/regreet; scrollmsg exit"
      '';

      environment.etc."greetd/hyprland.lua".text = ''
        hl.exec_cmd("${pkgs.regreet}/bin/regreet; hyprctl dispatch exit")

        hl.config({
          animations = { enabled = false, },
          misc = { disable_hyprland_logo = true, },
        })
      '';
    };
}
