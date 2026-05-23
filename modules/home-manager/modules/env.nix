{ ... }:

{
  flake.homeModules.env =
    { config, lib, ... }:
    let
      vars = {
        SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
      }
      // config.custom.externalVars;
    in
    {
      options.custom.externalVars = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Externally managed environment variables.";
      };

      config = {
        home.sessionVariables = vars;
        programs.nushell.environmentVariables = vars;
      };
    };
}
