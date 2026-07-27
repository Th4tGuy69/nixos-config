{ inputs, ... }:

{
  flake.nixosModules.niri =
    { ... }:
    {
      imports = [ inputs.niri.nixosModules.niri ];

      # programs.niri.enable = true;
    };
}
