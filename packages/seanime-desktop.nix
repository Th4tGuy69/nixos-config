{ pkgs, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "seanime-desktop";
  version = "2.7.0";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v2.7.0/seanime-desktop-2.7.0_Linux_x86_64.AppImage";
    hash = "sha256-9T8YC5jzC1fe77JFo6L7FT+ZWyGIhtg0zJoKEY24tfA=";
  };

  # https://github.com/5rahim/seanime/issues/205
  meta.broken = true;
}
