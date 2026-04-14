{ self, ... }:

{
  flake.nixosModules.desktopModule = {
    imports = with self.nixosModules; [
      desktopConfiguration
      desktopHardwareConfiguration
      desktopServices
      desktopPrograms
      desktopFlakes
      homeManager
      sops
    ];
  };
}
