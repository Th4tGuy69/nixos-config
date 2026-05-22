{ ... }:

{
  flake.nixosModules.regreet =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    lib.mkIf config.greeter.regreet.enable {
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
    };
}
