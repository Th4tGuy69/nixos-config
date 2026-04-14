{ ... }:

{
  flake.homeModules.direnv =
    { ... }:
    {
      programs.direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };
    };
}
