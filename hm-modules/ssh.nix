{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "RackNerd" = {
        hostname = "172.245.148.172";
        user = "root";
      };

      "Proxmox" = {
        hostname = "10.0.0.20";
        user = "root";
      };

      "Komodo" = {
        hostname = "10.0.0.154";
        user = "root";
      };
    };

    enableDefaultConfig = false;
    matchBlocks."*" = {
      identityAgent = "~/.bitwarden-ssh-agent.sock";

      # Default config
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
