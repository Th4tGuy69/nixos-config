{ ... }:

{
  flake.homeModules.hyprdarkwindow =
    { inputs, system, ... }:
    {
      wayland.windowManager.hyprland = {
        plugins = [
          inputs.hypr-darkwindow.packages.${system}.Hypr-DarkWindow
        ];
      };
    };
}
