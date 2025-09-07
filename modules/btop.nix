{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
    settings = {
      shown_boxes = "cpu mem net gpu0";
      base_10_sizes = true;
    };
  };
}
