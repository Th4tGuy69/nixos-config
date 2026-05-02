{ ... }:

{
  flake.homeModules.zoxide =
    { config, ... }:
    {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;  # bash is system default, always enable
        enableNushellIntegration = config.programs.nushell.enable;
      };
    };
}
