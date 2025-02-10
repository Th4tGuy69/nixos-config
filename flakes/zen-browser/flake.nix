{
  description = "Zen Browser";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;

      version = "1.7.6b";
      downloadUrl = {
        "x86_64-linux" = {
          url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
          sha256 = "sha256:19v6n0a1j63i8i7c9615lh1fmbz8jakwyiy11imc9vbq1n6z0nm9";
        };
        "aarch64-linux" = {
          url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-aarch64.tar.xz";
          sha256 = "";
        };
      };

      mkZen = system: 
        let
          pkgs = import nixpkgs { inherit system; };
          downloadData = downloadUrl.${system};

          runtimeLibs = with pkgs; [
            libGL libGLU libevent libffi libjpeg libpng libstartup_notification libvpx libwebp
            stdenv.cc.cc fontconfig libxkbcommon zlib freetype
            gtk3 libxml2 dbus xcb-util-cursor alsa-lib libpulseaudio pango atk cairo gdk-pixbuf glib
            udev libva mesa libnotify cups pciutils
            ffmpeg libglvnd pipewire
          ] ++ (with pkgs.xorg; [
            libxcb libX11 libXcursor libXrandr libXi libXext libXcomposite libXdamage
            libXfixes libXScrnSaver
          ]);

          desktopSrc = ./.;

        in pkgs.stdenv.mkDerivation {
          inherit version;
          pname = "zen-browser";

          src = builtins.fetchTarball {
            url = downloadData.url;
            sha256 = downloadData.sha256;
          };

          phases = [ "installPhase" "fixupPhase" ];

          nativeBuildInputs = [ pkgs.makeWrapper pkgs.copyDesktopItems pkgs.wrapGAppsHook ];

          installPhase = ''
            mkdir -p $out/bin && cp -r $src/* $out/bin

            # Check if zen.desktop exists before attempting installation
            if [ -f $desktopSrc/zen.desktop ]; then
              install -D $desktopSrc/zen.desktop $out/share/applications/zen.desktop
            fi

            install -D $src/browser/chrome/icons/default/default128.png $out/share/icons/hicolor/128x128/apps/zen.png
          '';

          fixupPhase = ''
            chmod 755 $out/bin/*
            for bin in zen zen-bin glxtest updater vaapitest; do
              patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/$bin
              wrapProgram $out/bin/$bin --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
            done
            wrapProgram $out/bin/zen --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
            wrapProgram $out/bin/zen-bin --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
          '';

          meta.mainProgram = "zen";
        };

    in {
      packages = forAllSystems (system: {
        zen-browser = mkZen system;
      });
    };
}
