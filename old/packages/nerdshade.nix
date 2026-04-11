{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "nerdshade";
  version = "latest";

  src = pkgs.fetchurl {
    url = "https://github.com/sstark/nerdshade/releases/latest/download/nerdshade";
    sha256 = "sha256-ADS3/Ux9p99ZOY4PYUWhy6FaMuStmnhshklJcUfrzBM="; 
  };

  dontUnpack = true;
  
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/nerdshade
    chmod +x $out/bin/nerdshade
  '';

  meta = with pkgs.lib; {
    description = "Screen shader for Hyprland using hyprsunset";
    homepage = "https://github.com/sstark/nerdshade";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
