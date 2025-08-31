{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "seanime";
  version = "2.9.9";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v${version}/seanime-${version}_Linux_x86_64.tar.gz";
    hash = "sha256-KfaJgLjQxV7+kDcGvZjqhz/nvPg4R+y9Mlknm5H1nCo=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    tar xzf $src -C $out/bin
  ''; 
}
