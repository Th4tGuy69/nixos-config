{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "future-cursors";
  version = "1.0"; 

  src = fetchFromGitHub {
    owner = "th4tguy69";
    repo = "Future-cursors";
    rev = "1004de3ec13113ff8f7fb3ffeb1b0deb2876b904"; 
    hash = "sha256-AWqJhcI2gB4rZ5nXS/3TmwW5HnFQP7OOsnIzE+/Gdso=";
  };

  installPhase = ''
    runHook preInstall

    # Default theme
    install -dm 755 $out/share/icons/Future-cursors
    cp -r $src/dist/* $out/share/icons/Future-cursors

    # Recolors
    for theme in cyan dark black; do
      install -dm 755 $out/share/icons/Future-$theme-cursors
      cp -r $src/Future-$theme-cursors/* $out/share/icons/Future-$theme-cursors
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "An x-cursor theme inspired by macOS and based on capitaine-cursors. Three color variations included: cyan, dark, and black.";
    homepage = "https://github.com/th4tguy69/Future-cursors";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ th4tguy69 ];
    platforms = platforms.linux;
  };
}


