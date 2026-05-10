{ ... }:

{
  flake.homeModules.prismlauncher =
    { pkgs, ... }:
    {
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
