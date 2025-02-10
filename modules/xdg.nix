{ ... }:

{
  xdg = {
    enable = true;
    
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/x-csharp" = [ "rider.desktop" "codium.desktop" ];
      };
    };
  };
}
