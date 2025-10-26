{ pkgs, config, inputs, ... }:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [ sops ];
  
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age-key.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
    secrets.test = {
      path = "%r/test.txt";
    }; 
  };
}
