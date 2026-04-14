{ ... }:

{
  flake.homeModules.walker =
    { ... }:
    {
      services.walker = {
        enable = true;
      };
    };
}
