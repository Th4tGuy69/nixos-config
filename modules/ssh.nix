{ ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "confirm";
    extraConfig = ''
      IdentityAgent ~/.bitwarden-ssh-agent.sock
    '';
  };
}
