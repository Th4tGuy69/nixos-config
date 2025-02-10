{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "seanime";
  version = "2.7.0";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v2.7.0/seanime-2.7.0_Linux_x86_64.tar.gz";
    hash = "sha256-757PtB5rdZR2w+SNbLIb13xwv32FxS2NdsUssWe3Zvg=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    tar xzf $src -C $out/bin
  '';

  meta = with pkgs.lib; {

  }; 
}
