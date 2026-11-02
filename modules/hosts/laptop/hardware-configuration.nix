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
            backdrop = "000000";
            wallpapers = [ ];
            wallpaperStyle = "stretched";

            interface = {
              branding = "gaming";
              brandingColor = "FFFFFF";
              helpColor = "AAAAAA";
              helpColorBright = "FFFFFF";
              helpHidden = true;
            };

            graphicalTerminal = {
              enable = true;

              background = "000000";
              foreground = "FFFFFF";

              brightBackground = "202020";
              brightForeground = "FFFFFF";

              margin = 32;
              marginGradient = 202020;

              font = {
                scale = "1";
                spacing = 1;
              };

              palette = "000000;404040;606060;808080;A0A0A0;C0C0C0;D0D0D0;FFFFFF";

              brightPalette = "202020;505050;707070;909090;B0B0B0;D0D0D0;E0E0E0;FFFFFF";
            };
          };

          extraConfig = ''
            # NixOS extraConfig
            quiet: yes
            terse: yes
            firmware_logo: yes
            comment: gaming
          '';
        };

        initrd = {
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
        kernelParams = [
          "quiet"
          "loglevel=3"
          "rd.udev.log_level=3"
          "systemd.show_status=false"
          "rd.systemd.show_status=false"
          "vt.global_cursor_default=0"
        ];
        consoleLogLevel = 0;
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
