{ config, lib, ... }:

let
  vars = {
    NIXOS_OZONE_WL = "1"; # Hint Electron apps to use Wayland
    SSH_AUTH_SOCK = "/home/thatguy/.bitwarden-ssh-agent.sock";
    SDL_VIDEO_DRIVER = "wayland";
    EDITOR = "hx";
  } // config.custom.externalVars;
in

{
  options.custom.externalVars = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {};
    description = "Externally managed environment variables.";
  };

  config = {
    home.sessionVariables = vars;
    programs.nushell.environmentVariables = vars;
  };
}
