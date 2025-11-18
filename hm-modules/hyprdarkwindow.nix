{
  pkgs,
  inputs,
  ...
}:

{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
    ];
  };
}
