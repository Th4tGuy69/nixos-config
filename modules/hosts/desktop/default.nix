{ self, ... }:

{
  flake.nixosModules.desktopModule = {
    imports = [
      self.nixosModules.desktopConfiguration
      self.nixosModules.desktopHardwareConfiguration
      self.nixosModules.homeManager
    ];
  };
}
