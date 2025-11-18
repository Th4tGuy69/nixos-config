{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      initial-command = "${pkgs.microfetch}/bin/microfetch; echo; nu";

      theme = "Carbonfox";

      keybind = [
        "alt+e=equalize_splits"
        "alt+t=new_tab"
        "ctrl+shift+tab=previous_tab"
        "ctrl+tab=next_tab"
        "alt+f=toggle_split_zoom"
        "alt+w=close_surface"
        "alt+up=goto_split:top"
        "alt+down=goto_split:bottom"
        "alt+left=goto_split:left"
        "alt+right=goto_split:right"
        "shift+alt+up=new_split:up"
        "shift+alt+down=new_split:down"
        "shift+alt+left=new_split:left"
        "shift+alt+right=new_split:right"
        "ctrl+alt+shift+up=resize_split:up,20"
        "ctrl+alt+shift+down=resize_split:down,20"
        "ctrl+alt+shift+left=resize_split:left,20"
        "ctrl+alt+shift+right=resize_split:right,20"
      ];
    };
  };
}
