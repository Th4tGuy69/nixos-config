{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "seanime";
  version = "2.6.2";

  src = pkgs.fetchurl {
    url = "https://github.com/5rahim/seanime/releases/download/v2.6.2/seanime-2.6.2_Linux_x86_64.tar.gz";
    hash = "sha256-gyn6OUp8l4NYL2L+mFKB+po9fq/4MgRAPCKVfUwe3a4=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    tar xzf $src -C $out/bin
  '';

  meta = with pkgs.lib; {

  }; 
}
