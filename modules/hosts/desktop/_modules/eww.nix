{ pkgs, ... }:

let
  ewwConfigDir = pkgs.writeTextDir "eww.yuck" ''
    (defwindow example
               :monitor 0
               :geometry (geometry :x "0%"
                                   :y "20px"
                                   :width "90%"
                                   :height "30px"
                                   :anchor "top center")
               :stacking "fg"
               :reserve (struts :distance "40px" :side "top")
               :windowtype "dock"
               :wm-ignore false
               :exclusive true
      "example content")
  '';
in
{
  programs.eww.enable = true;
  programs.eww.configDir = ewwConfigDir;

  home.file.".config/eww/eww.yuck".source = "${ewwConfigDir}/eww.yuck";
}

