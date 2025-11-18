{
  pkgs,
  inputs,
  system,
  ...
}:

{
  wayland.windowManager.hyprland = {
    plugins = with inputs.hyprland-plugins.packages.${system}; [
      hyprfocus
    ];

    settings = {
      animations.animation = [
        "hyprfocusIn, 1, 1.7, easeOutQuint"
      ];

      plugin.hyprfocus = {
        mode = "flash";
        fade_opacity = 0.85;
        bounce_strength = 0.95;
        slide_height = 20;
      };
    };
  };
}
