{ ... }:

{
  flake.homeModules.linux-wallpaperengine =
    { config, ... }:
    {
      services.linux-wallpaperengine = {
        enable = false;
        assetsPath = "${config.home.homeDirectory}/.steam";

        wallpapers = [
          {
            monitor = "DP-3";
            wallpaperId = "3565183295";
            fps = 30;
          }
        ];
      };
    };
}
