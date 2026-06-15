{ ... }:

{
  perSystem = { pkgs, ... }: {
    packages.keyguard = pkgs.mkDerivation rec {

      pname = "keyguard-desktop";
      version = "2.14.1";

      src = pkgs.fetchurl {
        url = "https://github.com/AChep/keyguard-app/releases/download/r${version}/Keyguard-${version}-linux-x86_64.tar.gz";
        sha256 = "sha256-f1ffb8e729ade79a16bd36f6a875e2c1b5c39353bb54e809b4a4ddbfed9bb402";
      };

      nativeBuildInputs = with pkgs; [
        autoPatchelfHook
        makeWrapper
      ];

      buildInputs = with pkgs; [
        stdenv.cc.cc.lib

        # graphics / Skiko
        libGL
        mesa

        # X11 (Skiko still depends on this even on Wayland)
        xorg.libX11
        xorg.libXext
        xorg.libXi
        xorg.libXrender
        xorg.libXrandr
        xorg.libXcursor

        # fonts
        fontconfig
        freetype

        # misc runtime deps
        zlib
      ];

      dontConfigure = true;
      dontBuild = true;
      dontStrip = true;

      unpackPhase = ''
        mkdir -p source
        tar -xzf $src -C source
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/keyguard
        cp -r source/* $out/lib/keyguard/

        # main binary
        chmod +x $out/lib/keyguard/bin/Keyguard

        mkdir -p $out/bin
        makeWrapper $out/lib/keyguard/bin/Keyguard $out/bin/keyguard \
          --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath buildInputs}"

        runHook postInstall
      '';
    };
  };
}
