{ ... }:

{
  flake.homeModules.xdg =
    { ... }:
    {
      xdg = {
        enable = true;

        portal.enable = true;
        portal.config.common.default = "*";

        mime.enable = true;
        mimeApps.enable = true;
      };
    };
}
