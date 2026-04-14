{ self, ... }:
{
  flake.nixosModules.desktopPrograms =
    { ... }:
    {
      imports = with self.nixosModules; [
        regreet
        appimage
        nix-ld
        steam
      ];

      programs = {
        hyprland.enable = true;
        gamescope.enable = true;
        gamemode.enable = true;
        coolercontrol.enable = true;
      };
    };
}
