{ ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      shown_boxes = "cpu mem net gpu0";
      base_10_sizes = true;
    };
  };
}
