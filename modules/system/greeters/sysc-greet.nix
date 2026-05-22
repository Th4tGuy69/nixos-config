{ inputs, ... }:

{
  flake.nixosModules.sysc-greet =
    {
      lib,
      config,
      ...
    }:
    {

      imports = [ inputs.sysc-greet.nixosModules.default ];
    }
    // lib.mkIf config.greeter.sysc-greet.enable {

      services.sysc-greet = {
        enable = true;
        # settings.initial_session = {
        #   command = "${
        #     inputs.scroll-flake.packages.${pkgs.system}.scroll-stable
        #   }/bin/scroll --config /etc/greetd/scroll.conf";
        #   user = "thatguy";
        # };
      };
    };
}
