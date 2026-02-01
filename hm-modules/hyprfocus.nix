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
        enabled = "yes";

        keyboard_focus_animation = "flash";
        mouse_focus_animation = "flash";

        flash = {
          flash_opacity = 0.85;

          in_bezier = "easeInQuint";
          # in_speed = ;

          out_bezier = "easeOutQuint";
          # out_speed = ;
        };
      };
    };
  };
}
