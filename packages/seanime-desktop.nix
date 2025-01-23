{ pkgs, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "seanime-desktop";
  version = "2.6.2";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v2.6.2/seanime-desktop-2.6.2_Linux_x86_64.AppImage";
    hash = "sha256-hWpz8MwFv3qTsdqlFYu91KC6cGfN0oVAfv2Dd8ZBOZQ=";
  };

  # https://github.com/5rahim/seanime/issues/205
  meta.broken = true;
}
