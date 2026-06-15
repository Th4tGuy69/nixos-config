{ inputs, ... }:

{
  flake.nixosModules.scroll =
    { pkgs, ... }:
    {
      imports = [ inputs.scroll-flake.nixosModules.default ];

      programs.scroll.enable = true;

      # xdg.portal.extraPortals = with pkgs; [
      #   xdg-desktop-portal
      #   xdg-desktop-portal-gtk
      #   xdg-desktop-portal-wlr
      # ];

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
