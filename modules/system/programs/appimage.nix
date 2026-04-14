{ ... }:

{
  flake.nixosModules.appimage =
    { pkgs, ... }:
    {
      programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs = pkgs: [
            pkgs.libxshmfence
          ];
        };
      };
    };
}
