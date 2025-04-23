{ ... }:

let
  vars = {
    NIXOS_OZONE_WL = "1"; # Hint Electron apps to use Wayland
    SSH_AUTH_SOCK = "/home/thatguy/.bitwarden-ssh-agent.sock";
  };
in

{
  home.sessionVariables = vars;
  programs.nushell.environmentVariables = vars;
}
