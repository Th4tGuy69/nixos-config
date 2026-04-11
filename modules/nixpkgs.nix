{ inputs, ... }:
let
  overlays = import ../overlays.nix { inherit inputs; };
in
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs { inherit system overlays; };
    };
}
