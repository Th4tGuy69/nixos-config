# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #inputs.home-manager.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true; # Set to false when using lanzaboote
      efi.canTouchEfiVariables = true;
      grub = {
        theme = "${(pkgs.sleek-grub-theme.override { withStyle = "dark"; })}/theme.txt";
        useOSProber = true;
      };
    };

    lanzaboote = {
      enable = false; # Not working "failed to install generation (os error 2)"
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
  };

  # Fix open file limit for system updates/upgrades
  systemd.extraConfig = ''
    DefaultLimitNOFILE=4096
  '';

  # Networking.
  networking = {
    hostName = "nixos";
    nameservers = [ "10.0.0.194" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager = {
      enable = true;
      dns = "none";
      plugins = [ pkgs.networkmanager-openconnect ];
    };
    #networkmanager.insertNameservers = [ "9.9.9.9" ];  
  
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
    exec-once = ${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit

    animations {
      enabled = false
    }

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        disable_hyprland_qtutils_check = true
    }
  '';

  # Greeter
  services.greetd = {
    enable = true;
    settings = {
      #default_session.command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
      default_session.command = "Hyprland --config /etc/greetd/hyprland.conf";
    };
  };
 
  programs.regreet = {
    enable = true;
    theme.package = pkgs.colloid-gtk-theme.override { themeVariants = [ "grey" ]; tweaks = [ "black" "rimless" "normal" ]; };
    theme.name = "Colloid-Grey-Dark";
  };
 
  # Programs
  programs = {
    hyprland.enable = true;
    gamescope.enable = true;
    gamemode.enable = true;
    coolercontrol.enable = true;  
    appimage.binfmt = true; # Enable running appimages directly
  };

  # GPU Driver
  hardware.graphics = {
    enable = true;
    ## radv: an open-source Vulkan driver from freedesktop
    enable32Bit = true;

    ## amdvlk: an open-source Vulkan driver from AMD
    extraPackages = [ pkgs.amdvlk ];
    extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
    amdvlk = {
      enable = true;
      supportExperimental.enable = true;
    };
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

  # Enable PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      vim
    ];
    shell = pkgs.nushell;
  };

  # Home manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "thatguy" = import ./home.nix;
    };
    backupFileExtension = "hm-backup";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    udev.packages = [ pkgs.via ];
    gnome.gnome-keyring.enable = true;
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
