{ ... }:

{
  flake.homeModules.direnv =
    { config, ... }:
    {
      programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = config.programs.nushell.enable;
        nix-direnv.enable = true;
      };
    };
}
