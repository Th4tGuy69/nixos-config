{ ... }:

{
  flake.homeModules.wlsunset =
    { lib, ... }:
    {
      services.wlsunset = {
        enable = true;
        latitude = 44.56;
        longitude = -123.27;
        temperature = {
          day = 4000;
          night = 1600;
        };
      };

      systemd.user.services.wlsunset = {
        Unit = {
          After = [ "scroll-session.target" ];
          BindsTo = [ "scroll-session.target" ];

          ConditionEnvironment = lib.mkForce "";
        };
      };
    };
}
