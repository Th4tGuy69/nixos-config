{ ... }:

{
  flake.homeModules.prismlauncher =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        wayland # libwayland-client error fix
      ];

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
