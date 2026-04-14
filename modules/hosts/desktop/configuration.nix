{ self, ... }:

{
  flake.nixosModules.desktopConfiguration =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        sbctl
        openrgb-with-all-plugins
        curlFull
        helix
      ];

      users.users.thatguy = {
        isNormalUser = true;
        description = "That Guy";
        extraGroups = [
          "networkmanager"
          "wheel"
          "audio"
          "kvm"
          "adbusers"
        ];
        shell = pkgs.nushell;
      };

      # Home manager
      home-manager.users.thatguy = self.homeModules.thatguyHome;

      # Fix open file limit for system updates/upgrades
      systemd = {
        settings.Manager.DefaultLimitNOFILE = 4096;

        services.nix-daemon.serviceConfig = {
          MemoryMax = "24G";
          MemorySwapMax = "8G";
        };
      };

      # Set your time zone.
      time.timeZone = "America/Los_Angeles";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      security = {
        # No sudo prompt for wheel
        sudo.wheelNeedsPassword = false;
        # Realtime audio
        rtkit.enable = true;
      };

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
          ]; # Flakes
          trusted-users = [
            "root"
            "thatguy"
            "@wheel"
          ]; # Extra System Permissions

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

      nix.extraOptions = "download-buffer-size = 1073741824";

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.11"; # Did you read the comment?
    };
}
