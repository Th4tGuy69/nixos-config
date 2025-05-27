{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "future-cyan-hyprcursor";
  version = "1.0"; 
  author = "Pummelfisch";

  src = pkgs.fetchFromGitLab {
    owner = author;
    repo = pname;
    rev = "44282bb5fe218b14f44af42368ef3c9ad439d646"; 
    hash = "sha256-Pi8+efEohVfH1iJ3oLcWLQuAOAZfR4iUOPmo4oyvrLE=";
  };

  installPhase = ''
    runHook preInstall

    # Default theme
    install -dm 755 $out/share/icons/Future-Cyan-Hyprcursor_Theme 
    cp -r Future-Cyan-Hyprcursor_Theme $out/share/icons/

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "A futuristic hyprcursor theme.";
    homepage = "https://gitlab.com/Pummelfisch/future-cyan-hyprcursor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ author ];
    platforms = platforms.linux;
  };
}


