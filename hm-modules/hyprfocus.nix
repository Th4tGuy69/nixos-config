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
