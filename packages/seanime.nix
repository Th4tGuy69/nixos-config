{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "seanime";
  version = "2.9.10";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v${version}/seanime-${version}_Linux_x86_64.tar.gz";
    hash = "sha256-OvBIPaPWP9JumOOeAPPb5La6Z1BhoNiVe1vJCB40BQE=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    tar xzf $src -C $out/bin
  ''; 
}
