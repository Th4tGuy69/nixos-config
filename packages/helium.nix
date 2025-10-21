{ pkgs, ... }:

let
  pname = "helium";
  version = "0.5.7.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256:03e7cd716eee8db798a8e6fe831cd0d29d7d275e1cb1f172a24d11551171a3ad";
  };

  extracted = pkgs.appimageTools.extractType2 { inherit pname version src; };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;

  # Create a proper executable in $out/bin/helium that launches the wrapped AppImage
  mainProgram = "helium";

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/256x256/apps

    # Copy the existing desktop file from the AppImage
    sed "s|Exec=helium|Exec=$out/bin/helium|" ${extracted}/helium.desktop \
      > $out/share/applications/helium.desktop

    # Copy the icon from the AppImage
    install -Dm644 ${extracted}/helium.png \
      $out/share/icons/hicolor/256x256/apps/helium.png
  '';
}
