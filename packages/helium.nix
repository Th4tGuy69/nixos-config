{ pkgs, ... }:

let
  pname = "Helium";
  version = "0.5.7.1";

  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256:03e7cd716eee8db798a8e6fe831cd0d29d7d275e1cb1f172a24d11551171a3ad";
  };
in
pkgs.appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/${pname}.desktop <<EOF
    [Desktop Entry]
    Version=1.0
    Name=Helium
    Comment=Browse the web with Helium
    Exec=${pname} %U
    Terminal=false
    Icon=${pname}
    Type=Application
    Categories=Network;WebBrowser;
    MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/mailto;
    StartupNotify=true
    StartupWMClass=Helium
    EOF
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

