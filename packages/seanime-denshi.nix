{ pkgs, ... }:

let
  pname = "seanime-denshi";
  version = "3.2.2";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v${version}/seanime-denshi-${version}_Linux_x86_64.AppImage";
    hash = "sha256-magAoZDNY3rLX9thEVDPbRZj68/K+lJ6+kbMD0yTyvk=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };

in
pkgs.appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/seanime-denshi.desktop $out/share/applications/seanime-denshi.desktop
    install -Dm644 ${appimageContents}/seanime-denshi.png $out/share/pixmaps/seanime-denshi.png

    substituteInPlace $out/share/applications/seanime-denshi.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with pkgs.lib; {
    description = "Seanime is a free and open-source media server that allows you to manage and enjoy your anime and manga collection with ease.";
    homepage = "https://seanime.app";
    downloadPage = "https://seanime.app/download";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
