{ self, ... }:

{
  flake.nixosModules.desktopVars =
    { ... }:
    {
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        SDL_VIDEO_DRIVER = "wayland";
        EDITOR = "hx";
      };
    };
}
