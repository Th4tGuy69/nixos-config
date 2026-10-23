{ self, ... }:
{
  flake.nixosModules.laptopPrograms =
    { ... }:
    {
      imports = with self.nixosModules; [
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
