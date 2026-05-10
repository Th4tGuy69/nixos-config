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
          "keys"
        ];
        shell = pkgs.nushell;
      };

      # Home manager
      home-manager.users.thatguy = self.homeModules.thatguyHome;

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

      nix.settings.trusted-users = [ "thatguy" ];

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.11"; # Did you read the comment?
    };
}
