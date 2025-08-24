{ inputs, pkgs, ... }:

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
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      height = { absolute = 0; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = false;
      showResultsImmediately = true;
      maxEntries = null;

      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        dictionary
        #kidex # Need to install kidex daemon first (not in nixpkgs)
        #randr
        rink
        shell
        #stdin
        #symbols
        translate
        websearch # Doesn't respect config
        nix-run
        # niri-focus
      ];
    };

    extraCss = ''
      @define-color bg-col  rgba(0, 0, 0, 0.66);
      @define-color border-col #CCCCCC;
      @define-color fg-col #CCCCCC;

      * {
        transition: 110ms ease; 
        font-family: "FiraCode Nerd Font Mono";
        font-size: 1rem;
      }

      #window {
        background: transparent;
      }

      #plugin,
      #main {
        color: @fg-col;
        background-color: transparent;
      }

      /* anyrun's input window - Text */
      #entry {
        color: @fg-col;
        background-color: @bg-col;
        border: 2px solid @border-col;
      }

      /* anyrun's ouput matches entries - Base */
      #match {
        color: @fg-col;
        border-radius: 10px;
        background-color: @bg-col;
        border: 2px solid @bg-col;
      }

      /* anyrun's selected entry */
      #match:selected {
        border-radius: 10px;
        border-color: @border-col;
        border: 2px solid;
        color: @fg-col;
      }

      #entry, #plugin:hover {
        border-radius: 10px;
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
