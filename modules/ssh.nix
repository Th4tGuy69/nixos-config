{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "Proxmox" = {
        hostname = "10.0.0.20";
        user = "root";
        identityAgent = "~/.bitwarden-ssh-agent.sock";
      };

      "Chemeketa" = {
        hostname = "198.199.108.39";
        user = "cgarre25";
      };

      "Access" = {
        hostname = "access.engr.oregonstate.edu";
        user = "garrecad";
        identityFile = "~/.ssh/osu.pem";
      };

      "Flip1" = {
        hostname = "flip1.engr.oregonstate.edu";
        user = "garrecad";
        identityFile = "~/.ssh/osu.pem";
      };

      "Flip2" = {
        hostname = "flip2.engr.oregonstate.edu";
        user = "garrecad";
        identityFile = "~/.ssh/osu.pem";
      };

      "Flip3" = {
        hostname = "flip3.engr.oregonstate.edu";
        user = "garrecad";
        identityFile = "~/.ssh/osu.pem";
      };

      "Rabbit" = {
        hostname = "rabbit.engr.oregonstate.edu";
        user = "garrecad";
        identityFile = "~/.ssh/osu.pem";
      };

      "OS1" = {
        hostname = "os1.engr.oregonstate.edu";
        user = "garrecad";
        proxyJump = "Access";
      };

      "OS2" = {
        hostname = "os2.engr.oregonstate.edu";
        user = "garrecad";
        proxyCommand = "ssh -W %h:%p Access";
      };

      "github.com" = {
        user = "git";
        identityAgent = "~/.bitwarden-ssh-agent.sock";
      };

      "RackNerd" = {
        hostname = "172.245.148.172";
        user = "root";
        identityAgent = "~/.bitwarden-ssh-agent.sock";
      };

      "Komodo" = {
        hostname = "10.0.0.154";
        user = "root";
        identityAgent = "~/.bitwarden-ssh-agent.sock";
      };

      "Dockge" = {
        hostname = "10.0.0.194";
        user = "root";
        identityAgent = "~/.bitwarden-ssh-agent.sock";
      };
    };

    enableDefaultConfig = false;    
    matchBlocks."*" = { # Default config
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
  };
}
