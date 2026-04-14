{ inputs, ... }:

{
  flake.homeModules.sops =
    { pkgs, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      home.packages = with pkgs; [ sops ];

      sops = {
        age.keyFile = "/home/thatguy/.config/sops/age/keys.txt";
        defaultSopsFile = ../../secrets/secrets.yaml;
      };

      custom.externalVars = {
        SOPS_AGE_KEY_FILE = "/home/thatguy/.config/sops/age/keys.txt";
      };
    };
}
