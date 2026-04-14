{ ... }:

{
  flake.homeModules.hyprchroma =
    { inputs, system, ... }:
    {
      wayland.windowManager.hyprland = {
        plugins = [
          inputs.hyprchroma.packages.${system}.Hypr-DarkWindow
        ];
      };
    };
}
