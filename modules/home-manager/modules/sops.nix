{ inputs, ... }:

{
  flake.homeModules.sops =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      home.packages = with pkgs; [ sops ];

      sops = {
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        defaultSopsFile = ../../secrets/secrets.yaml;

        secrets = {
          latitude = { };
          longitude = { };
        };
      };

      custom.externalVars = {
        SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      };
    };
}
