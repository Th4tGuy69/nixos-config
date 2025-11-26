{ ... }:

{
  services.linux-wallpaperengine = {
    enable = true;

    assetsPath = "/home/thatguy/.steam/steam/steamapps/workshop/content/431960";

    wallpapers = [
      {
        monitor = "DP-3";
        wallpaperId = "3522907624";
      }
    ];
  };
}
