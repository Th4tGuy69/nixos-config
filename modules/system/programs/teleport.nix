{ ... }:

{
  flake.nixosModules.teleport = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.teleport ];
  };
}
