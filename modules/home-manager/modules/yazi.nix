{ ... }:

{
  flake.homeModules.yazi =
    { ... }:
    {
      programs.yazi = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
}
