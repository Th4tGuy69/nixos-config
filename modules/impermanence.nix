{ inputs, ... }:

{
  flake.nixosModules.impermanence =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      options.persistence =
        let
          entry = with lib.types; listOf (either str (attrsOf str));
        in
        {
          directories = lib.mkOption {
            type = entry;
            default = [ ];
          };
          files = lib.mkOption {
            type = entry;
            default = [ ];
          };
        };

      config = {
        fileSystems."/persistent".neededForBoot = true;

        environment.persistence."/persistent" = {
          hideMounts = true;
          inherit (config.persistence) directories files;
        };

        boot.initrd.systemd = {
          enable = true;
          initrdBin = with pkgs; [
            btrfs-progs
            findutils
          ];

          services.impermanence = {
            wantedBy = [ "initrd.target" ];
            requires = [ "dev-mapper-crypted.device" ];
            before = [ "sysroot.mount" ];
            after = [ "dev-mapper-crypted.device" ];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = ''
              set -e

              mkdir /btrfs_tmp
              mount /dev/mapper/crypted /btrfs_tmp || exit 1

              if [[ -e /btrfs_tmp/root ]]; then
                mkdir -p /btrfs_tmp/old_roots
                timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
                mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
              fi

              delete_subvolume_recursively() {
                IFS=$'\n'
                for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/btrfs_tmp/$i"
                done
                btrfs subvolume delete "$1"
              }

              if [[ -d /btrfs_tmp/old_roots ]]; then
                for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mindepth 1 -mtime +7); do
                  delete_subvolume_recursively "$i"
                done
              fi

              btrfs subvolume create /btrfs_tmp/root
              umount /btrfs_tmp
            '';
          };
        };
      };
    };
}
