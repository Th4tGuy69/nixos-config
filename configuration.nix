# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  inputs,
  system,
  ...
}:

let
  subs = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://hyprland.cachix.org"
    "https://anyrun.cachix.org"
  ];
in

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./secrets/sops.nix

    ./modules/newt.nix
    ./modules/scroll.nix
  ];

  _module.args.system = pkgs.stdenv.hostPlatform.system;

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = pkgs.lib.mkForce false; # Set to false when using lanzaboote
      efi.canTouchEfiVariables = true;
      grub = {
        theme = "${(pkgs.sleek-grub-theme.override { withStyle = "dark"; })}/theme.txt";
        useOSProber = true;
      };
    };

    lanzaboote = {
      enable = true; # Not working "failed to install generation (os error 2)"
      pkiBundle = "/var/lib/sbctl";
    };

    kernelModules = [ "nct6775" ];
    #kernelPatches = [
    #  {
    #    name = "amdgpu-ignore-ctx-privileges";
    #    patch = pkgs.fetchpatch {
    #      name = "cap_sys_nice_begone.patch";
    #      url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
    #      hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
    #    };
    #  }
    #];

    plymouth = {
      enable = true;

      # theme = ;
      # font = ;
    };
  };

  # Swap file
  swapDevices = [
    {
      device = "/data/swapfile";
      size = 32 * 1024; # 32 GB
      options = [ "discard" ];
    }
  ];

  # Fix open file limit for system updates/upgrades
  systemd = {
    settings.Manager.DefaultLimitNOFILE = 4096;

    services.nix-daemon.serviceConfig = {
      MemoryMax = "24G";
      MemorySwapMax = "8G";
    };
  };

  # Networking
  services.dnscrypt-proxy = {
    enable = false;
    settings = {
      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];

      bootstrap_resolvers = [
        "9.9.9.9:53"
        "149.112.112.112:53"
      ];

      ipv6_servers = true; # IPv6 support
      http3 = true; # HTTPS w/ QUIC support

      # Allow DNS logs and filters
      require_nolog = false;
      require_nofilter = false;

      # Multiple server names - dnscrypt-proxy will try them in order
      # Mix your custom server with public fallbacks
      server_names = [
        "DoH"
        "quad9"
      ];

      static = {
        # "QUIC".stamp = "sdns://BAEAAAAAAAAADzE3Mi4yNDUuMTQ4LjE3MgAUZG5zLnRoYXQtZ3V5LmRldjo4NTM"; # Not supported
        "DoH".stamp = "sdns://AgEAAAAAAAAADzE3Mi4yNDUuMTQ4LjE3MgAQZG5zLnRoYXQtZ3V5LmRldgovZG5zLXF1ZXJ5";
        # "DoT".stamp = "sdns://AwEAAAAAAAAADzE3Mi4yNDUuMTQ4LjE3MgAUZG5zLnRoYXQtZ3V5LmRldjo4NTM"; # Malformed or not supported
        # "DNS".stamp = "sdns://AAEAAAAAAAAADzE3Mi4yNDUuMTQ4LjE3Mg";
      };
    };
  };

  networking = {
    hostName = "nixos";
    nameservers = [
      "9.9.9.9"
      "1.1.1.1"
      # "127.0.0.1"
      # "::1"
    ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager = {
      enable = true;
      dns = "none";
    };

    # Firewall
    #firewall = {
    #  allowedTCPPorts = [
    #    8384 22000 22067 22070 # Syncthing
    #  ];
    #  allowedUDPPorts = [
    #    22000 21027 # Syncthing
    #    57621 # Spotify
    #  ];
    #};
  };

  services.syncthing.openDefaultPorts = true;

  #environment.etc = {
  #  "resolv.conf".text = "nameserver 9.9.9.9\n";
  #};
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  environment.etc."greetd/hyprland.conf".text = ''
    exec-once = ${pkgs.regreet}/bin/regreet; hyprctl dispatch exit

    animations {
      enabled = false
    }

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
    }
  '';

  # programs.niri.enable = true;

  # Greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.hyprland}/bin/Hyprland --config /etc/greetd/hyprland.conf";
    };
  };

  programs.regreet = {
    enable = true;
    theme.package = pkgs.colloid-gtk-theme.override {
      themeVariants = [ "grey" ];
      tweaks = [
        "black"
        "rimless"
        "normal"
      ];
    };
    theme.name = "Colloid-Grey-Dark";
  };

  # Musnix
  musnix = {
    enable = true;

    alsaSeq.enable = true;
    ffado.enable = false;
    rtcqs.enable = true;

    kernel = {
      realtime = true;
      packages = pkgs.linuxPackages_latest_rt;
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Programs
  programs = {
    hyprland.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    coolercontrol.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override {
        extraPkgs = pkgs: [
          pkgs.xorg.libxshmfence
        ];
      };
    };
    adb.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib
      ];
    };
  };

  # GPU Driver
  hardware.graphics = {
    enable = true;
    ## radv: an open-source Vulkan driver from freedesktop
    enable32Bit = true;
  };

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Steam hardware
  hardware.steam-hardware.enable = true; # VR
  hardware.xone.enable = true; # XBox
  hardware.xpadneo.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pulseaudio.extraConfig = [
    "load-module module-null-sink"
  ];

  # Razer
  hardware.openrazer = {
    enable = true;
    users = [ "thatguy" ];
  };

  # Enable trash folder and networking for nautilus
  services.gvfs.enable = true;

  security = {
    # No sudo prompt for wheel
    sudo.wheelNeedsPassword = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
    packages = with pkgs; [
      vim
    ];
    shell = pkgs.nushell;
  };

  # Home manager
  home-manager = {
    extraSpecialArgs = { inherit system inputs; };
    users = {
      "thatguy" = import ./home.nix;
    };
    backupFileExtension = "hm-backup";
  };

  # Stylix
  stylix = {
    enable = true;

    base16Scheme = {
      base00 = "000000"; # Default Background (pure black for OLED)
      base01 = "171717"; # Lighter Background (very dark gray)
      base02 = "2e2e2e"; # Selection Background (dark gray)
      base03 = "4b4b4b"; # Comments, Invisibles (medium gray)
      base04 = "787878"; # Dark Foreground (medium gray)
      base05 = "a0a0a0"; # Default Foreground (light gray - OLED safe)
      base06 = "b8b8b8"; # Light Foreground (lighter gray - OLED safe)
      base07 = "d0d0d0"; # Light Background (light gray - OLED safe)
      base08 = "e53e3e"; # Variables, XML Tags, Markup Link Text (coral/red)
      base09 = "dd6b20"; # Integers, Boolean, Constants (orange)
      base0A = "f6e05e"; # Classes, Markup Bold, Search Text Background (light yellow)
      base0B = "48bb78"; # Strings, Inherited Class, Markup Code (mint green)
      base0C = "38b2ac"; # Support, Regular Expressions (teal)
      base0D = "4299e1"; # Functions, Methods, Attribute IDs (sky blue)
      base0E = "9f7aea"; # Keywords, Storage, Selector (purple)
      base0F = "ed64a6"; # Deprecated, Opening/Closing Embedded Language Tags (pink)
    };

    targets = {
      plymouth.enable = false;
      regreet.enable = false;
    };
  };

  # Nix
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    sbctl
    openrgb-with-all-plugins
    curlFull
  ];

  nix.extraOptions = ''download-buffer-size = 1073741824'';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services = {
    hardware.openrgb.enable = true;
    udev.packages = [
      pkgs.via
      pkgs.vial
      pkgs.qmk-udev-rules
    ];
    gnome.gnome-keyring.enable = true;
    envfs.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = false;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
