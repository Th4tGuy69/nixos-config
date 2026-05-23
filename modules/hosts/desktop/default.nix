{ self, ... }:

{
  flake.nixosModules.desktopModule = {
    imports = with self.nixosModules; [
      hostsCommon
      desktopConfiguration
      desktopHardwareConfiguration
      desktopServices
      desktopPrograms
      desktopFlakes
      desktopVars
    ];
  };
}
