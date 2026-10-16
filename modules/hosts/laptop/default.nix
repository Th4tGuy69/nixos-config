{ self, ... }:

{
  flake.nixosModules.laptopModule = {
    imports = with self.nixosModules; [
      hostsCommon
      laptopConfiguration
      laptopHardwareConfiguration
      laptopPersistence
      laptopServices
      laptopPrograms
      laptopFlakes
      laptopVars
    ];
  };
}
