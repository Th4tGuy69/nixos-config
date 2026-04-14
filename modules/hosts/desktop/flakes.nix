{ self, ... }:

{
  flake.nixosModules.desktopFlakes =
    { ... }:
    {
      imports = with self.nixosModules; [
        stylix
        # musnix
      ];
    };
}
