{ config, lib, inputs, ... }:

{
  flake.homeModules.hyprwinwrap =
    { pkgs, config, inputs, system, ... }:
    let
      clock-bg = pkgs.writeShellScriptBin "clock-bg" ''
        #!${pkgs.bash}/bin/bash
        ${pkgs.clock-rs}/bin/clock-rs -bst --fmt "%A, %B %d, %Y"
      '';
    in
    {
      # Only enable if hyprland is enabled
      home.packages = lib.optional (config.gui.windowManager == "hyprland") [
        pkgs.clock-rs
        pkgs.bash
        pkgs.kitty
      ];

      wayland.windowManager.hyprland = lib.optionalAttrs (config.gui.windowManager == "hyprland") {
        plugins = with inputs.hyprland-plugins.packages.${system}; [
          hyprwinwrap
        ];

        settings = {
          exec-once = [
            "${pkgs.kitty}/bin/kitty --class 'clock-bg' ${clock-bg}/bin/clock-bg"
          ];

          plugin.hyprwinwrap = {
            class = "clock-bg";
            title = "clock-bg";
          };
        };
      };
    };
}
