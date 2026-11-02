{ inputs, ... }:

{
  flake.homeModules.ironbar = { ... }: {
    imports = [ inputs.ironbar.homeManagerModules.default ];

    programs.ironbar = {
      enable = true;

      # config = {
      #   monitors.eDP-1 = {
      #     position = "bottom";
      #     height = 16;
      #     start = [
      #       {
      #         type = "clock";
      #       }
      #     ];
      #     end = [
      #       {
      #         type = "tray";
      #         icon_size = 16;
      #       }
      #     ];
      # };
      # };
    };
  };
}
