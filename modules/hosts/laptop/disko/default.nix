{ inputs, self, ... }:

{
  flake.diskoConfigurations.laptop = import ./_layout.nix;

  flake.nixosModules.laptopDisko =
    { lib, ... }:
    {
      imports =
        with inputs;
        with self;
        [
          disko.flakeModule
          disko.nixosModules.disko

          ./_layout.nix
        ];
    };
}
