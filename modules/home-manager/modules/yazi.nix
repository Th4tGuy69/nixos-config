{ ... }:

{
  flake.homeModules.yazi =
    { config, ... }:
    {
      programs.yazi = {
        enable = true;
        enableNushellIntegration = config.programs.nushell.enable;
      };
    };
}
