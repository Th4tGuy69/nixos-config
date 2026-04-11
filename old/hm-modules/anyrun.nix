{
  inputs,
  pkgs,
  system,
  ...
}:

let
  shutdown-script = pkgs.writeShellScriptBin "shutdown" ''
    #!/bin/bash
    shutdown now
  '';

  reboot-script = pkgs.writeShellScriptBin "reboot" ''
    #!/bin/bash
    reboot
  '';
in

{
  programs.anyrun = {
    enable = true;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
      height = {
        absolute = 0;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = null;

      plugins = with inputs.anyrun.packages.${system}; [
        applications
        dictionary
        #kidex # Need to install kidex daemon first (not in nixpkgs)
        #randr
        rink
        shell
        #stdin
        #symbols
        translate
        websearch
        nix-run
        niri-focus
      ];
    };

    extraCss = ''
      @define-color theme_selected_bg_color #CCCCCC;
      @define-color theme_bg_color #000000;

      * {
        font-family: "FiraCode Nerd Font Mono";
        font-weight: 500;
      }

      window {
        background: transparent;
      }

      box.main {
        padding: 5px;
        margin: 10px;
        border-radius: 10px;
        border: 2px solid @theme_selected_bg_color;
        background-color: @theme_bg_color;
        box-shadow: 0 0 5px black;
      }

      text {
        min-height: 30px;
        padding: 5px;
        border-radius: 5px;
      }

      .matches {
        background-color: rgba(0, 0, 0, 0);
        border-radius: 10px;
      }

      box.plugin:first-child {
        margin-top: 5px;
      }

      box.plugin.info {
        min-width: 200px;
      }

      list.plugin {
        background-color: rgba(0, 0, 0, 0);
      }

      label.match.description {
        font-size: 10px;
      }

      label.plugin.info {
        font-size: 14px;
      }

      .match {
        background: transparent;
      }

      .match:selected {
        background: transparent;
        color: white;
      }

      @keyframes fade {
        0% {
          opacity: 0;
        }

        100% {
          opacity: 1;
        }
      }
    '';

    extraConfigFiles."websearch.ron".text = ''
      // Managed by Home Manager
      Config(
        prefix: "?",
        engines: [Custom(
          name: "SearXNG",
          url: "search.that-guy.dev/search?q={}",
        ), Google]
      )
    '';

    extraConfigFiles."nix-run.ron".text = ''
      // Managed by Home Manager
      Config(
        prefix: ":nr ",
        // Whether or not to allow unfree packages
        allow_unfree: true,
        // Nixpkgs channel to get the package list from
        channel: "nixpkgs-unstable",
        max_entries: 3,
      )
    '';
  };

  xdg.desktopEntries.shutdown = {
    name = "Shutdown";
    exec = "${shutdown-script}/bin/shutdown";
    type = "Application";
    terminal = true;
    icon = "utilities-terminal";
  };

  xdg.desktopEntries.reboot = {
    name = "Reboot";
    exec = "${reboot-script}/bin/reboot";
    type = "Application";
    terminal = true;
    icon = "utilities-terminal";
  };
}
