{ inputs, ... }:

{
  flake.nixosModules.niri =
    { ... }:
    {
      imports = [ inputs.niri.nixosModules.niri ];
    };
}
