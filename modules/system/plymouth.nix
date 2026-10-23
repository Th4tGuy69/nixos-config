{ ... }:

{
  flake.nixosModules.plymouth = { pkgs, ... }: {
    boot.plymouth = {
      enable = true;
      theme = "nixos-bgrt";
      themePackages = [ pkgs.nixos-bgrt-plymouth ];
    };
  };
}
