{ pkgs, ... }:

pkgs.appimageTools.wrapType2 rec {
  pname = "seanime-desktop";
  version = "2.9.7";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v${version}/seanime-desktop-${version}_Linux_x86_64.AppImage";
    hash = "sha256-XEuoeBXCZXOmhIGXvYLsV9N291x88STHo5a8NNkMdaI=";
  };

  # https://github.com/5rahim/seanime/issues/205
  meta.broken = true;
}
