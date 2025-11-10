{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "seanime";
  version = "3.0.1";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v${version}/seanime-${version}_Linux_x86_64.tar.gz";
    hash = "sha256-qwnBEX56KawWRXKSyJ/GxNHiprzzXT2b8eorZdJcqUA=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    tar xzf $src -C $out/bin
  ''; 
}
