{ inputs, ... }:

{
  flake.nixosModules.sops =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        age.keyFile = "/home/${config.user.name}/.config/sops/age/keys.txt";
        defaultSopsFile = ./secrets.yaml;
      };
    };
}
