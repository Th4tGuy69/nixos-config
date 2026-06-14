{ ... }:

{
  perSystem =
    { pkgs, ... }:
    let
      pname = "seanime-denshi";

      manifest = builtins.readFile (
        builtins.fetchurl {
          url = "https://github.com/5rahim/seanime/releases/latest/download/latest-linux.yml";
          sha256 = "sha256:0j128nklkdhhlxh59svpc5zyx25414yprhr1ja41pxrxv41hkwn6";
        }
      );

      version = builtins.head (builtins.match ".*version: ([0-9.]+).*" manifest);
      sha512 = builtins.head (builtins.match ".*\nsha512: ([A-Za-z0-9+/=]+)\n.*" manifest);

      src = pkgs.fetchurl {
        url = "https://github.com/5rahim/seanime/releases/latest/download/seanime-denshi-${version}_Linux_x86_64.AppImage";
        inherit sha512;
      };

      appimageContents = pkgs.appimageTools.extractType2 {
        inherit pname version src;
      };
    in
    {
      packages.seanime-denshi = pkgs.appimageTools.wrapType2 rec {
        inherit pname version src;

        extraInstallCommands = ''
          install -Dm644 ${appimageContents}/seanime-denshi.desktop $out/share/applications/seanime-denshi.desktop
          install -Dm644 ${appimageContents}/seanime-denshi.png $out/share/pixmaps/seanime-denshi.png

          substituteInPlace $out/share/applications/seanime-denshi.desktop \
            --replace-fail 'Exec=AppRun' 'Exec=${pname}'
        '';

        meta = with pkgs.lib; {
          description = "Seanime is a free and open-source media server that allows you to manage and enjoy your anime and manga collection with ease.";
          homepage = "https://seanime.app";
          downloadPage = "https://seanime.app/download";
          license = licenses.gpl3;
          platforms = [ "x86_64-linux" ];
          mainProgram = pname;
        };
      };
    };
}
