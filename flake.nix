{
  description = "NixOS Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      type = "path";
      path = "/etc/nixos/flakes/zen-browser";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # quickshell = {
    #   url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow/tags/v0.36.0";
      # url = "github:micha4w/Hypr-DarkWindow";
      inputs.hyprland.follows = "hyprland";
    };

    hyprchroma = {
      url = "github:alexhulbert/Hyprchroma";
      inputs.hyprland.follows = "hyprland";
    };

    musnix.url = "github:musnix/musnix";

    niri.url = "github:sodiboo/niri-flake";

    wayvid = {
      url = "github:YangYuS8/wayvid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = with inputs; [
          ./configuration.nix
          home-manager.nixosModules.default
          stylix.nixosModules.stylix
          sops-nix.nixosModules.sops
          lanzaboote.nixosModules.lanzaboote
          musnix.nixosModules.musnix
        ];
      };
    };
}
