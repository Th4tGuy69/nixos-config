{ pkgs, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "seanime-desktop";
  version = "2.7.5";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v${version}/seanime-desktop-${version}_Linux_x86_64.AppImage";
    hash = "sha256-4EHSill73l7+19/NoCrQxag+ThZFBDx4z872Jt+8P9k=";
  };

  # https://github.com/5rahim/seanime/issues/205
  meta.broken = true;
}
