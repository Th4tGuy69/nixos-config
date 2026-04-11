{ inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];
 
  sops = {
    age.keyFile = "/home/thatguy/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
  };
}
