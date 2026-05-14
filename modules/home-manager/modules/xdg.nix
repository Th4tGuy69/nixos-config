{ ... }:

{
  flake.homeModules.xdg =
    { pkgs, ... }:
    {
      xdg = {
        enable = true;

        portal.enable = true;
        portal.extraPortals = with pkgs; [
          xdg-desktop-portal
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];

        mime.enable = true;
        mimeApps.enable = true;
      };
    };
}
