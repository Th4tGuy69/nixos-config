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
        #websearch # Doesn't respect config
      ];
    };

    extraCss = ''
#window {
  background-color: rgba(0,0,0,0.66);
}

list#main, box#main, list#plugin, label#plugin, label#main-desc {
  background-color: rgba(0,0,0,0);
  color: rgba(117,117,117,1);
  border-color: rgba(117,117,117,1);
}
    '';
    
    extraConfigFiles."websearch.ron".text = ''
prefix: "?",
Custom(
  name: "SearXNG",
  url: "search.that-guy.dev/search?q={}",
)
engines: [SearXNG]
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
