{ self, ... }:

{
  flake.nixosModules.desktopServices =
    { ... }:
    {
      imports = with self.nixosModules; [
        greeter
        audio
        udev
        ollama

        # openssh
        # dnscrypt
      ];

      services = {
        hardware.openrgb.enable = true;
        gnome.gnome-keyring.enable = true;
        envfs.enable = true;
        flatpak.enable = true;
        gvfs.enable = true; # Trash folder and networking for nautilus
        syncthing.openDefaultPorts = true;
      };
    };
}
