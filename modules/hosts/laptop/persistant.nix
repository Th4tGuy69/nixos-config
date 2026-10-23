{ self, ... }:

{

  flake.nixosModules.laptopPersistence =
    { ... }:
    {
      persistence = {
        directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/NetworkManager"
          "/var/lib/bluetooth"
          "/var/lib/coredump"
          "/var/lib/fprint"
          "/var/lib/fwupd"
          "/var/lib/nixos"
          "/var/lib/sbctl"
          "/var/lib/systemd"
          {
            directory = "/etc/nixos";
            user = "thatguy";
            group = "users";
          }
        ];

        files = [
          "/etc/machine-id"
        ];
      };
    };
}
