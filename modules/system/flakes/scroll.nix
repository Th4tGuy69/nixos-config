{ inputs, ... }:

{
  flake.nixosModules.scroll =
    { ... }:
    {
      imports = [ inputs.scroll-flake.nixosModules.default ];

      programs.scroll.enable = true;

      # Enable Pipewire for screencasting and audio server
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
      };
    };
}
