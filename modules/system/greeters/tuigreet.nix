{ ... }:

{
  flake.nixosModules.tuigreet =
    { pkgs, lib, ... }:
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          user = "greeter";
          command = lib.getExe pkgs.tuigreet;
        };
      };

      environment.etc."tuigreet/config.toml".source = (pkgs.formats.toml { }).generate "tuigreet.toml" {
        remember = {
          username = true;
          user_session = true;
        };
        display = {
          align_greeting = "center";
          issue = false;
          show_time = false;
        };
        layout = {
          width = 50;
          window_padding = 1;
          container_padding = 1;
          prompt_padding = 1;
          widgets.status_position = "hidden";
        };
        secret = {
          mode = "characters";
          characters = "●";
        };
        theme = {
          border = "black";
          text = "dark_gray";
          title = "black";
          greet = "dark_gray";
          prompt = "dark_gray";
          input = "white";
          action = "dark_gray";
          button = "dark_gray";
          container = "black";
        };
      };

      persistence.directories = [ "/var/cache/tuigreet" ];
    };
}
