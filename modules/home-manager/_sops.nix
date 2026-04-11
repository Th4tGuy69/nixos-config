{ pkgs, config, inputs, ... }:

{
  flake.homeModules.sops = {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  
  config = {   
    home.packages = with pkgs; [ sops ];
  
    sops = {
      age.keyFile = "/home/thatguy/.config/sops/age/keys.txt";
      defaultSopsFile = ../secrets/secrets.yaml;
    };

    custom.externalVars = {
      SOPS_AGE_KEY_FILE = "/home/thatguy/.config/sops/age/keys.txt";
    };
  };
  };
}
