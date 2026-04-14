{ ... }:

{
  flake.homeModules.zoxide =
    { ... }:
    {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
      };
    };
}
