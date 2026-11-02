{ self, ... }:
{
  flake.nixosModules.laptopPrograms =
    { ... }:
    {
      imports = with self.nixosModules; [
        appimage
        nix-ld
        teleport
      ];

      # programs = { };
    };
}
