{ self, config, ... }:

{
  flake.nixosModules.hostsCommon =
    { ... }:
    {
      imports = with self.nixosModules; [
        homeManager
        sops
      ];

      # Nix
      nixpkgs.config.allowUnfree = true;

      nix.settings =
        let
          subs = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
            "https://hyprland.cachix.org"
            "https://anyrun.cachix.org"
          ];
        in
        {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ];

          # Build Cache
          substituters = subs;
          trusted-substituters = subs;

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
          ];
        };

      nix.extraOptions = ''
        download-buffer-size = 1073741824
        keep-outputs = false
        keep-derivations = false
      '';

      # Fix open file limit for system updates/upgrades
      systemd = {
        settings.Manager.DefaultLimitNOFILE = 4096;

        services.nix-daemon.serviceConfig = {
          MemoryMax = "24G";
          MemorySwapMax = "8G";
        };
      };
    };
}
