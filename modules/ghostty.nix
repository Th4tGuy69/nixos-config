{ inputs, ... }:

{
  programs.ghostty = {
    enable = true;
    
    themes.Wez = {
      palette = [
        "0=#000000"
        "1=#cc5555"
        "2=#55cc55"
        "3=#cdcd55"
        "4=#5555cc"
        "5=#cc55cc"
        "6=#7acaca"
        "7=#cccccc"
        "8=#555555"
        "9=#ff5555"
        "10=#55ff55"
        "11=#ffff55"
        "12=#5555ff"
        "13=#ff55ff"
        "14=#55ffff"
        "15=#ffffff"
      ];
      background = "#000000";
      foreground = "#b3b3b3";
      cursor-color = "#53ae71";
      selection-background = "#4d52f8";
      selection-foreground = "#000000";
    };

    settings = {
      initial-command = "microfetch; echo; nu";
   
      theme = "Wez";
 
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
