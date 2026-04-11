{ ... }:

{
  services.linux-wallpaperengine = {
    enable = false;
    assetsPath = "/home/thatguy/.steam";

    wallpapers = [
      {
        monitor = "DP-3";
        wallpaperId = "3565183295";
        fps = 30;
      }
    ];
  };
}
