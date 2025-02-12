{ pkgs, ... }:

let
  future-cursors = import ../packages/future-cursors.nix { 
    lib = pkgs.lib; 
    stdenvNoCC = pkgs.stdenvNoCC;
    fetchFromGitHub = pkgs.fetchFromGitHub; 
  };
in

{
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  home.sessionVariables.GTK_THEME = "Colloid-Dark";

  gtk = {
    enable = true;
    theme = {
      package = pkgs.colloid-gtk-theme.override { themeVariants = [ "grey" ]; tweaks = [ "black" "rimless" "normal" ];  };
      name = "Colloid-Grey-Dark";
    };
    #iconTheme = {
    #  package = pkgs.colloid-icon-theme.override { colorVariants = [ "grey" ]; };
    #  name = "Colloid-Grey-Dark";
    #};
    cursorTheme = {
      package = future-cursors;
      name = "Future-cursors";
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  };

  home.packages = with pkgs; [
    qt6.qtwayland
    qt5.qtwayland
  ];

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      package = pkgs.colloid-kde;
      name = "ColloidDark";
    };
  };
}
