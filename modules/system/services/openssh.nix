{ ... }:

{
  flake.nixosModules.openssh =
    { ... }:
    {
      services.openssh = {
        enable = false;
        ports = [ 22 ];
        settings = {
          PasswordAuthentication = false;
          AllowUsers = null;
          UseDns = true;
          X11Forwarding = false;
          PermitRootLogin = "no";
        };
      };
    };
}
