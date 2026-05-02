{ config, lib, inputs, ... }:

{
  flake.homeModules.hyprfocus =
    { pkgs, config, inputs, ... }:
    {
      # Only configure if hyprland is enabled
      programs.hyprland.settings = lib.optionalAttrs (config.gui.windowManager == "hyprland") {
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
}
