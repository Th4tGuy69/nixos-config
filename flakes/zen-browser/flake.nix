{
  description = "Zen Browser";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems f;

      version = "1.13.2b";
      downloadUrl = {
        "x86_64-linux" = {
          url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
          sha256 = "sha256:0hmb3zxjn961nd6c0ry5mbcr2iq38i1rvqs31qg99c7mcsv6zjal";
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

          zenDesktop = pkgs.writeText "zen.desktop" ''
            [Desktop Entry]
            Name=Zen Browser
            Exec=zen %u
            Icon=zen
            Type=Application
            MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;application/x-xpinstall;application/pdf;application/json;
            StartupWMClass=zen-alpha
            Categories=Network;WebBrowser;
            StartupNotify=true
            Terminal=false
            X-MultipleArgs=false
            Keywords=Internet;WWW;Browser;Web;Explorer;
            Actions=new-window;new-private-window;profilemanager;

            [Desktop Action new-window]
            Name=Open a New Window
            Exec=zen %u

            [Desktop Action new-private-window]
            Name=Open a New Private Window
            Exec=zen --private-window %u

            [Desktop Action profilemanager]
            Name=Open the Profile Manager
            Exec=zen --ProfileManager %u 
          '';

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
            install -D ${zenDesktop} $out/share/applications/zen.desktop
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
