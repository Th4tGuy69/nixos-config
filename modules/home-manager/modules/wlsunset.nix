{ ... }:

{
  flake.homeModules.wlsunset =
    { ... }:
    {
      services.wlsunset = {
        enable = false; # Not working with scroll or the greeter
        latitude = 44.56;
        longitude = -123.27;
        temperature = {
          day = 4000;
          night = 1600;
        };
      };
    };
}
