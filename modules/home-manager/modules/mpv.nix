{ ... }:

{
  flake.homeModules.mpv =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        mpv
        (writeShellApplication {
          name = "mpv-url-decoder";
          runtimeInputs = [ pkgs.mpv pkgs.xdg-utils ]; 
          text = ''
            #!/usr/bin/env bash
            urldecode() { : "''${*//+/ }"; echo -e "''${_//%/\\x}"; }

            if [[ "$1" == "mpv:"* ]]; then
              ref="''${1#mpv://stream?}"
              url="$(urldecode "''${ref}")"
              exec mpv "''${url}"
            else
              exec xdg-open "$1"
            fi
          '';
        })
      ];

      xdg.desktopEntries.mpv-scheme = {
        name = "MPV scheme handler";
        comment = "Open mpv:// links with MPV.";
        exec = "mpv-url-decoder %u";
        icon = "mpv";
        terminal = false;
        type = "Application";
        mimeType = [ "x-scheme-handler/mpv" ];
        noDisplay = true;
      };

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/mpv" = [ "mpv-scheme.desktop" ];
      };
    };
}
