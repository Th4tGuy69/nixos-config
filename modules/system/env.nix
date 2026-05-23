{ self, ... }:

{
  flake.nixosModules.env =
    { ... }:
    {
      environment.sessionVariables = self.lib.env;
    };
}
