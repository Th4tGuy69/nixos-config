{ ... }:

{
  flake.homeModules.xdg =
    { pkgs, ... }:
    {
      xdg = {
        enable = true;

        portal = {
          enable = true;
          extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
          config.common.default = "gtk";
        };

        mime.enable = true;
        mimeApps.enable = true;
      };
    };
}
