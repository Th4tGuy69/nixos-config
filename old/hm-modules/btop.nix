{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
    settings = {
      update_ms = 1300;
      shown_boxes = "cpu mem net gpu0";
      base_10_sizes = true;
      disks_filter = "exclude=/boot /windows";
    };
  };
}
