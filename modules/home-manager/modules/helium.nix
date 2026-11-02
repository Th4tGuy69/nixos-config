{ ... }:

{
  flake.homeModules.helium =
    { inputs, pkgs, ... }:
    {
      home.packages = [ inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
