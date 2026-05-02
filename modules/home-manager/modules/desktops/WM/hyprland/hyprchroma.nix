{ config, lib, inputs, ... }:

{
  flake.homeModules.hyprchroma =
    { pkgs, config, inputs, system, ... }:
    {
      # Only add plugin if hyprland is enabled
      wayland.windowManager.hyprland.plugins = 
        lib.optional (config.gui.windowManager == "hyprland") inputs.hyprchroma.packages.${system}.Hypr-DarkWindow;
    };
}
