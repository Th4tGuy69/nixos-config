{ ... }:

{
  flake.nixosModules.nix-ld =
    { pkgs, ... }:
    {
      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          zlib
          wayland
          libxkbcommon
        ];
      };
    };
}
