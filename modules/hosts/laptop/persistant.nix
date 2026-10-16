{ inputs, ... }:

{
  flake.nixosModules.laptopPersistence =
    { ... }:
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      environment.persistence."/persistent" = {
        hideMounts = true;

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
