{ inputs, self, ... }:

{
  flake.nixosModules.desktopHardwareConfiguration = {
    imports = [
      inputs.disko.flakeModule
      self.nixosModules.impermanence

      ./_layout.nix
    ];
  };
}
