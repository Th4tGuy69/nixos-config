{ ... }:

{
  flake.homeModules.persistence = { lib, config, ... }: {
    options.persistence =
      let
        entry = with lib.types; listOf (either str (attrsOf str));
      in
      {
        directories = lib.mkOption {
          type = entry;
          default = [ ];
        };
        files = lib.mkOption {
          type = entry;
          default = [ ];
        };
      };

    config.home.persistence."/persistent" = {
      inherit (config.persistence) directories files;
    };
  };
}
