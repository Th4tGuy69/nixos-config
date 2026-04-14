{ inputs, ... }:
let
  overlays = import ../../overlays.nix { inherit inputs; };
in
{
  flake.nixosModules.homeManager =
    { ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.default
      ];

      home-manager = {
        backupFileExtension = "hm-backup";
        extraSpecialArgs = { inherit inputs; };
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      nixpkgs.overlays = overlays;
    };
}
