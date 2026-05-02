{ lib, ... }:

{
  flake.homeModules.git =
    { config, pkgs, lib, ... }:
    {
      options.git = {
        name = lib.mkOption {
          type = lib.types.str;
          default = config.user.name;
          description = "Name for git commits";
        };
        email = lib.mkOption {
          type = lib.types.str;
          default = null;
          description = "Email for git commits";
        };
      };

      config.programs.git = rec {
        enable = true;
        package = pkgs.git.override { withLibsecret = true; };
        lfs.enable = true;
        signing.format = "ssh";

        settings = {
          user.name = config.git.name;
          user.email = config.git.email;

          credential.helper = "${package}/bin/git-credential-libsecret";
        };
      };
    };
}
