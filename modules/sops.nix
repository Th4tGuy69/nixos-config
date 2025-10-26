{ pkgs, config, inputs, ... }:

{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.packages = with pkgs; [ sops ];
  
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age-key.txt"; # must have no password!
    # It's also possible to use a ssh key, but only when it has no password:
    #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
    # defaultSopsFile = "${config.home.homeDirectory}/.config/sops/secrets.yaml";
    defaultSopsFile = ../secrets/secrets.yaml; # Must be absolute
    # defaultSopsFile = "/home/thatguy/.config/sops/secrets.yaml";
    # defaultSopsFile = builtins.toString ../secrets/secrets.yaml;
    
    secrets.test = {
      # sopsFile = ./secrets.yml.enc; # optionally define per-secret files

      # %r gets replaced with a runtime directory, use %% to specify a '%'
      # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
      # DARWIN_USER_TEMP_DIR) on darwin.
      path = "%r/test.txt";
    }; 
  };
}
