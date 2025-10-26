{ inputs, system, ... }:

{
  home.packages = [
    inputs.zen-browser.packages.${system}.zen-browser
  ];

  xdg.mimeApps = {
    defaultApplicationPackages = [
       inputs.zen-browser.packages.${system}.zen-browser
    ];
       
    associations.added = {
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/chrome" = [ "zen.desktop" ];
      "text/html" = [ "zen.desktop" ];
      "application/x-extension-htm" = [ "zen.desktop" ];
      "application/x-extension-html" = [ "zen.desktop" ];
      "application/x-extension-shtml" = [ "zen.desktop" ];
      "application/xhtml+xml" = [ "zen.desktop" ];
      "application/x-extension-xhtml" = [ "zen.desktop" ];
      "application/x-extension-xht" = [ "zen.desktop" ];
    };
  };
}
