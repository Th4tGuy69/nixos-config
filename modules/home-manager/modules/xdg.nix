{ ... }:

{
  flake.homeModules.xdg =
    { ... }:
    {
      xdg = {
        enable = true;

        portal.enable = true;
        portal.config.common.default = "gtk";

        mime.enable = true;
        mimeApps.enable = true;
      };
    };
}
