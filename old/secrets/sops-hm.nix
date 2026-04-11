{ pkgs, config, inputs, ... }:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  
  config = {   
    home.packages = with pkgs; [ sops ];
  
    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ../secrets/secrets.yaml;
    };

    custom.externalVars = {
      SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
  };
}
