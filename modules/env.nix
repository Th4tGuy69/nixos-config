{ ... }:

let
  vars = {
    NIXOS_OZONE_WL = "1"; # Hint Electron apps to use Wayland
    SSH_AUTH_SOCK = "/home/thatguy/.bitwarden-ssh-agent.sock";
    SDL_VIDEO_DRIVER = "wayland";
    EDITOR = "hx";
  };
in

{
  home.sessionVariables = vars;
  programs.nushell.environmentVariables = vars;
}
