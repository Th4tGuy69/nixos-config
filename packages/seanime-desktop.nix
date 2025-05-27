{ pkgs, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "seanime-desktop";
  version = "2.8.4";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v${version}/seanime-desktop-${version}_Linux_x86_64.AppImage";
    hash = "sha256-H8yqsgWEj+e0VvTDpvavsC0AVf9voI2nVDwsCzq8X8U=";
  };

  # https://github.com/5rahim/seanime/issues/205
  meta.broken = true;
}
