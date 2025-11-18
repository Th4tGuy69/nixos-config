{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    settings = {
      initial-command = "${pkgs.microfetch}/bin/microfetch; echo; nu";

      theme = "Carbonfox";

      keybind = [
        "ctrl+shift+c=text:\\x03"
        "ctrl+e=equalize_splits"
        "ctrl+t=new_tab"
        "ctrl+tab=next_tab"
        "ctrl+shift+tab=previous_tab"
        "ctrl+f=toggle_split_zoom"
        "ctrl+w=close_surface"
        "ctrl+c=copy_to_clipboard"
        "ctrl+v=paste_from_clipboard"
        "ctrl+up=goto_split:top"
        "ctrl+down=goto_split:bottom"
        "ctrl+left=goto_split:left"
        "ctrl+right=goto_split:right"
        "ctrl+alt+up=new_split:up"
        "ctrl+alt+down=new_split:down"
        "ctrl+alt+left=new_split:left"
        "ctrl+alt+right=new_split:right"
        "ctrl+shift+up=resize_split:up,20"
        "ctrl+shift+down=resize_split:down,20"
        "ctrl+shift+left=resize_split:left,20"
        "ctrl+shift+right=resize_split:right,20"
      ];
    };
  };
}
