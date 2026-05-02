{ self, ... }:

{
  flake.nixosModules.minimalModule = {
    imports = with self.nixosModules; [
      hostsCommon
      minimalConfiguration
      desktopHardwareConfiguration
    ];
  };
}
