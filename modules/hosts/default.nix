{ inputs, self, ... }:

{
  flake.nixosConfigurations = with inputs.nixpkgs.lib; with self.nixosModules; {
    nixos = nixosSystem {
      modules = [ desktopModule ];
    };

    laptop = nixosSystem {
      modules = [ laptopModule ];
    };

    minimal = nixosSystem {
      modules = [ minimalModule ];
    };
  };

  flake.nixosModules.minimalModule = {
    imports = with self.nixosModules; [
      hostsCommon
      minimalConfiguration
      desktopHardwareConfiguration
    ];
  };
}
