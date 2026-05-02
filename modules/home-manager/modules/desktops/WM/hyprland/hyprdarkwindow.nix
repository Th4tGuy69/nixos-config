{ config, lib, inputs, ... }:

{
  flake.homeModules.hyprdarkwindow =
    { pkgs, config, inputs, system, ... }:
    {
      # Only add plugin if hyprland is enabled
      wayland.windowManager.hyprland.plugins = 
        lib.optional (config.gui.windowManager == "hyprland") inputs.hypr-darkwindow.packages.${system}.Hypr-DarkWindow;
    };
}
