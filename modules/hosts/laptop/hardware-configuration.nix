{ inputs, self, ... }:

{
  flake.nixosModules.laptopHardwareConfiguration =
    { lib, ... }:
    {
      imports =
        with inputs;
        with self;
        [
          nixos-hardware.nixosModules.framework-amd-ai-300-series

          nixosModules.laptopDisko
          nixosModules.impermanence
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

        plymouth.enable = true;

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
      };

      security.tpm2.enable = true;
      services.fprintd.enable = true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = true;
    };
}
