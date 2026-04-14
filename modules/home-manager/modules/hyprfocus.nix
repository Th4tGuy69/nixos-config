{ ... }:

{
  flake.homeModules.hyprfocus =
    { pkgs, inputs, ... }:
    {
      wayland.windowManager.hyprland = {
        plugins = with inputs.hyprland-plugins.packages.x86_64-linux; [
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

              out_bezier = "easeOutQuint";
            };
          };
        };
      };
    };
}
