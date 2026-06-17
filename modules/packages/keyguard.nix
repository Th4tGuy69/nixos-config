{ ... }:

{
  perSystem =
    { pkgs, ... }:
    let
      release = builtins.fromJSON (
        builtins.readFile (
          pkgs.fetchurl {
            url = "https://api.github.com/repos/AChep/keyguard-app/releases/latest";
            sha256 = "sha256-fsAGNUQSw2WglR81e8Iot3y1mHYdDPz3UlTu6GyrJ2U=";
          }
        )
      );

      tag = release.tag_name;
      appVersion = builtins.elemAt (builtins.match "Release v([0-9]+\\.[0-9]+\\.[0-9]+)-.*" release.name) 0;
    in
    {
      packages.keyguard = pkgs.stdenv.mkDerivation rec {
        pname = "keyguard-desktop";
        version = appVersion;

        src = pkgs.fetchurl {
          url = "https://github.com/AChep/keyguard-app/releases/download/${tag}/Keyguard-${appVersion}-linux-x86_64.tar.gz";
          sha256 = "sha256-53ZByjMU+0xB1BNY5ZyArhmmUM1IqgGYb5nYwuG+b3g=";
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

          substituteInPlace $out/share/applications/com.artemchep.keyguard.desktop \
            --replace "Exec=Keyguard" "Exec=keyguard %U"
            
          mkdir -p $out/share/icons
          cp -r $out/lib/keyguard/Keyguard/share/icons/* \
             $out/share/icons/

          runHook postInstall
        '';
      };
    };
}
