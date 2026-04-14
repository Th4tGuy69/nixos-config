{ ... }:

{
  flake.nixosModules.regreet =
    { pkgs, ... }:
    {
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
