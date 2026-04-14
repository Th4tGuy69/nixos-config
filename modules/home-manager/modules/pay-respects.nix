{ ... }:

{
  flake.homeModules.pay-respects =
    { ... }:
    {
      programs.pay-respects = {
        enable = true;

        enableBashIntegration = true;
        enableNushellIntegration = true;
      };
    };
}
