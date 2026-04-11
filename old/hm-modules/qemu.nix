{ pkgs, ... }:

let
  windows-launcher = pkgs.writeScriptBin "windows" ''
    #!${pkgs.bash}/bin/bash
    cd /data/VMs
    quickemu --vm ./windows-10-English.conf
    #exec ${pkgs.bash}/bin/bash
    read -p "Press any key to exit"
  '';
in

{
  home.packages = with pkgs; [ 
    qemu quickemu
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
    qemu-system-x86_64 \
      -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
      "$@"
    '')
  ];

  xdg.desktopEntries.qemu-windows = {
    name = "Windows 10";
    exec = "${windows-launcher}/bin/windows";
    type = "Application";
    terminal = true;
  };
}
