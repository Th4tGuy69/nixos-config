{ ... }:

{
  xdg = {
    enable = true;

    portal.enable = true;
    
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/x-csharp" = [ "rider.desktop" "codium.desktop" ];
      };
    };
  };
}
