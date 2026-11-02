{ ... }:

{
  flake.nixosModules.plymouth = { ... }: {
    boot.plymouth.enable = true;
  };
}
