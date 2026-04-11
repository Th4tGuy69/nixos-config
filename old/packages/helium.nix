{ pkgs, ... }:

let
  pname = "helium";
  version = "0.5.7.1";
  
  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256:03e7cd716eee8db798a8e6fe831cd0d29d7d275e1cb1f172a24d11551171a3ad";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

in
pkgs.appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
    install -Dm644 ${appimageContents}/helium.png $out/share/pixmaps/helium.png
    
    substituteInPlace $out/share/applications/helium.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with pkgs.lib; {
    description = "Helium — a lightweight Chrome fork for web browsing";
    homepage = "https://helium.computer";
    downloadPage = "https://github.com/imputnet/helium?tab=readme-ov-file#downloads";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
