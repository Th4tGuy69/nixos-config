{ ... }:

{
  flake.homeModules.pay-respects =
    { config, ... }:
    {
      programs.pay-respects = {
        enable = true;

        enableBashIntegration = true;
        enableNushellIntegration = config.programs.nushell.enable;
      };
    };
}
