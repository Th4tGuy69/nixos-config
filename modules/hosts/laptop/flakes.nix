{ self, ... }:

{
  flake.nixosModules.laptopFlakes =
    { ... }:
    {
      imports = with self.nixosModules; [
        stylix
        musnix
        scroll
      ];
    };
}
