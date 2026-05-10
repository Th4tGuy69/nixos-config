{ ... }:

{
  flake.homeModules.prismlauncher =
    { pkgs, ... }:
    {
      # libwayland-client error fix
      home.sessionVariables = {
        LD_LIBRARY_PATH =
          with pkgs;
          lib.makeLibraryPath [
            wayland
          ];
      };

      programs.prismlauncher = {
        enable = true;
        extraPackages = [ ];
        package =
          with pkgs;
          (prismlauncher.override {
            jdks = [
              graalvmPackages.graalvm-ce
              zulu8
              zulu17
              zulu
            ];
          });
        settings = { };
      };
    };
}
