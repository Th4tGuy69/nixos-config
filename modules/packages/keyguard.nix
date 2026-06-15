{ ... }:

{
  perSystem =
    { pkgs, lib, ... }:
    let
      release = builtins.fromJSON (
        builtins.readFile (
          pkgs.fetchurl {
            url = "https://api.github.com/repos/AChep/keyguard-app/releases/latest";
            sha256 = "sha256-2tAfrx8aDh4cFoba0l8pE9MGMdQWvGJ3vuhEn4TFQ4g=";
          }
        )
      );

      tag = release.tag_name;
    in
    {
      packages.keyguard = pkgs.stdenv.mkDerivation rec {
        pname = "keyguard-desktop";
        version = tag;

        src = pkgs.fetchurl {
          url = "https://github.com/AChep/keyguard-app/releases/download/${tag}/Keyguard-2.14.1-linux-x86_64.tar.gz";
          sha256 = "sha256-8f+45ymt55oWvTb2qHXiwbXDk1O7VOgJtKTdv+2btAI=";
        };

        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.makeWrapper
        ];

        buildInputs = with pkgs; [
          stdenv.cc.cc.lib

          libGL
          mesa

          libX11
          libXext
          libXi
          libXrender
          libXrandr
          libXcursor
          libXtst

          alsa-lib
          fontconfig
          freetype
          zlib
        ];

        dontConfigure = true;
        dontBuild = true;

        unpackPhase = ''
          mkdir -p src
          tar -xzf $src -C src
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/lib/keyguard
          cp -r src/* $out/lib/keyguard/

          BIN=$out/lib/keyguard/Keyguard/bin/Keyguard

          chmod +x $BIN

          mkdir -p $out/bin
          makeWrapper $BIN $out/bin/keyguard \
            --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath buildInputs}"

          mkdir -p $out/share/applications
          cp $out/lib/keyguard/Keyguard/share/applications/*.desktop \
             $out/share/applications/

          mkdir -p $out/share/icons
          cp -r $out/lib/keyguard/Keyguard/share/icons/* \
             $out/share/icons/

          runHook postInstall
        '';
      };
    };
}
