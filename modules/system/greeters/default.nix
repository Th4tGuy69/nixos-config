{ self, ... }:

{
  flake.nixosModules.greeter =
    { lib, ... }:
    {
      imports = with self.nixosModules; [
        sysc-greet
        greetd
        regreet
      ];

      options.greeter = {
        sysc-greet.enable = lib.mkEnableOption "sysc-greet" // {
          default = true;
        };
        regreet.enable = lib.mkEnableOption "regreet" // {
          default = false;
        };
        greetd.enable = lib.mkEnableOption "greetd" // {
          default = false;
        };
      };
    };
}
