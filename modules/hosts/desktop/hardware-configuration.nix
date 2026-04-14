{ inputs, ... }:

{
  flake.nixosModules.desktopHardwareConfiguration =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot = {
        loader = {
          systemd-boot.enable = pkgs.lib.mkForce false; # Set to false when using lanzaboote
          efi.canTouchEfiVariables = true;
          # grub = {
          #   theme = "${(pkgs.sleek-grub-theme.override { withStyle = "dark"; })}/theme.txt";
          #   useOSProber = true;
          # };
        };

        lanzaboote = {
          enable = true;
          pkiBundle = "/var/lib/sbctl";
          autoGenerateKeys.enable = true;
          autoEnrollKeys.enable = true;
        };

        plymouth = {
          enable = true;

          # theme = ;
          # font = ;
        };

        initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        initrd.kernelModules = [ ];
        kernelModules = [
          "kvm-amd"
          "nct6775"
        ];
        # kernelPatches = [
        #   {
        #     name = "amdgpu-ignore-ctx-privileges";
        #     patch = pkgs.fetchpatch {
        #       name = "cap_sys_nice_begone.patch";
        #       url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        #       hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        #     };
        #   }
        # ];
        extraModulePackages = [ ];
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/4cc70096-48c2-4d52-9f3f-e99205266b94";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
      };

      fileSystems."/data" = {
        device = "/dev/disk/by-label/Data";
        fsType = "btrfs";
        options = [ "exec" ];
      };

      # Enable NTFS support
      boot.supportedFilesystems = [ "ntfs" ];

      fileSystems."/windows" = {
        device = "/dev/disk/by-label/Windows";
        fsType = "ntfs-3g";
        options = [
          "rw"
          "uid=1000"
        ];
      };

      swapDevices = [
        {
          device = "/data/swapfile";
          size = 32 * 1024; # 32 GB
          options = [ "discard" ];
        }
      ];

      # Networking
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

        # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
        # (the default) this is the recommended approach. When using systemd-networkd it's
        # still possible to use this option, but it's recommended to use it in conjunction
        # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
        useDHCP = lib.mkDefault true;
        # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
        # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

        # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

        # Configure network proxy if necessary
        # networking.proxy.default = "http://user:password@proxy:port/";
        # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
      };

      hardware = {

        bluetooth.enable = true;

        enableRedistributableFirmware = true;
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        graphics = {
          enable = true;
          enable32Bit = true;
        };

        amdgpu = {
          opencl.enable = true;
          initrd.enable = true;
        };
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    };
}
