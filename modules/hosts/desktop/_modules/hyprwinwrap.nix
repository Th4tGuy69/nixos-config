{
  pkgs,
  inputs,
  system,
  ...
}:

let
  clock-bg = pkgs.writeShellScriptBin "clock-bg" ''
    #!${pkgs.bash}/bin/bash
    # ${pkgs.coreutils}/bin/sleep 1 && ${pkgs.cava}/bin/cava
    ${pkgs.clock-rs}/bin/clock-rs -bst --fmt "%A, %B %d, %Y"
    # /home/thatguy/Documents/Projects/rinow/target/debug/rinow
  '';
in

{
  home.packages = [
    pkgs.clock-rs
    pkgs.bash
    pkgs.kitty
  ];

  wayland.windowManager.hyprland = {
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
}
