{ inputs, self, ... }:

{
  flake.nixosModules.laptopHardwareConfiguration =
    { lib, pkgs, ... }:
    {
      imports =
        with inputs;
        with self;
        with nixosModules;
        [
          nixos-hardware.nixosModules.framework-amd-ai-300-series

          laptopDisko
          plymouth
          impermanence
        ];

      boot = {
        loader.limine = {
          enable = true;
          maxGenerations = 10;
          secureBoot.enable = false;

          style = {
            wallpapers = [ ];
            interface = {
              branding = "gaming";
              helpHidden = true;
            };
          };

          extraEntries = ''
            # NixOS extraEntries
            quiet: yes
            terse: yes
            firmware_logo: yes
            comment: gaming
          '';
        };

        initrd = {
          systemd.enable = true;
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "thunderbolt"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
        kernelModules = [ "kva-amd" ];
        extraModulePackages = [ ];

        plymouth = {
          theme = "framework";
          themePackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.framework-plymouth-theme ];
        };
      };

      security.tpm2.enable = true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = true;

      networking.hostName = "fw13pro";
    };
}
