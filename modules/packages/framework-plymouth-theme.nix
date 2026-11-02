{ ... }:

{
  perSystem =
    { pkgs, ... }:
    let
      pname = "framework-plymouth-theme";
      version = "1.0.0";

      frameworkSvg = pkgs.fetchurl {
        name = "framework.svg";
        url = "https://cdn.simpleicons.org/framework/ffffff";
        hash = "sha256-JolkYApM7VjJgHWfQM4uzBmixQ6lFpjq0aFTom76uvY=";
      };

      lockSvg = pkgs.fetchurl {
        name = "lock-fill.svg";
        url = "https://icons.getbootstrap.com/assets/icons/lock-fill.svg";
        hash = "sha256-j71A/2Hp/ELfRPE50LQJtQG0LRy96fQ/XNXqJc8HswQ=";
      };
    in
    {
      packages.${pname} = pkgs.stdenvNoCC.mkDerivation {
        inherit pname version;

        nativeBuildInputs = [
          pkgs.librsvg
          pkgs.imagemagick
        ];

        dontUnpack = true;

        installPhase = ''
          runHook preInstall

          themeDir="$out/share/plymouth/themes/framework"
          mkdir -p "$themeDir"

          # Render, trim, and center an SVG in a square canvas.
          renderIcon() {
            local source="$1"
            local size="$2"
            local output="$3"
            local raw="''${output%.png}-raw.png"

            rsvg-convert \
              -w "$size" \
              -h "$size" \
              "$source" \
              -o "$raw"

            local dimensions
            dimensions=$(magick "$raw" -trim +repage \
              -format '%[fx:max(w,h)]' info:)

            local padding=$((size * 21 / 100))
            local canvasSize=$((size + padding * 2))

            magick "$raw" \
              -background none \
              -gravity center \
              -extent "''${canvasSize}x''${canvasSize}" \
              "$output"
          }

          renderIcon ${frameworkSvg} 512 "$themeDir/spinner.png"

          # Bootstrap lock icon uses currentColor.
          sed 's/currentColor/#ffffff/' ${lockSvg} > lock.svg
          renderIcon lock.svg 256 "$themeDir/lock.png"

          # Auxiliary images.
          magick -size 64x64 xc:none \
            -fill '#ffffff' \
            -draw 'circle 32,32 32,2' \
            "$themeDir/bullet.png"

          magick -size 16x16 xc:'#ffffff' "$themeDir/line.png"

          # Plymouth theme configuration.
          cat > "$themeDir/framework.plymouth" <<EOF
          [Plymouth Theme]
          Name=Framework
          Description=Theme based around the Framework logo
          ModuleName=script

          [script]
          ImageDir=$themeDir
          ScriptFile=$themeDir/framework.script
          EOF

          cat > "$themeDir/framework.script" <<'EOF'
          Window.SetBackgroundTopColor(0.043, 0.043, 0.055);
          Window.SetBackgroundBottomColor(0.043, 0.043, 0.055);

          # Display dimensions and center.
          sw = Window.GetWidth();
          sh = Window.GetHeight();
          cx = sw / 2;
          cy = sh / 2;

          # Layout.
          logoSize = Math.Int(Math.Min(sw * 0.15, sh * 0.20));
          lockSize = Math.Int(logoSize * 0.20);
          barWidth = Math.Int(logoSize * 0.80);
          barHeight = Math.Max(2, Math.Int(logoSize * 0.012));

          MAX_DOTS = 8;
          dotSpacing = barWidth / MAX_DOTS;
          dotSize = Math.Int(dotSpacing * 0.75);

          spinnerGap = Math.Int(logoSize * 0.35);
          barGap = Math.Int(logoSize * 0.07);

          dotsY = cy + logoSize / 2 + spinnerGap;
          barY = dotsY + dotSize + barGap;

          # Spinner animation.
          PI = 3.14159265;
          FRAMES = 540;

          spinnerCanvasSize = Math.Int(logoSize * 1.42);

          spinnerBase = Image("spinner.png").Scale(
            spinnerCanvasSize,
            spinnerCanvasSize
          );

          spinner = Sprite(spinnerBase);
          spinner.SetX(cx - spinnerCanvasSize / 2);
          spinner.SetY(cy - spinnerCanvasSize / 2);
          spinner.SetZ(10);

          for (i = 0; i < FRAMES; i++) {
            phase = i / FRAMES;
            frames[i] = spinnerBase.Rotate(phase * 2 * PI);
          }

          frame = 0;

          fun refresh() {
            frame = (frame + 1) % FRAMES;
            spinner.SetImage(frames[frame]);
          }

          Plymouth.SetRefreshFunction(refresh);

          # Center lock icon.
          lockImage = Image("lock.png").Scale(lockSize, lockSize);
          lock = Sprite(lockImage);
          lock.SetX(cx - lockSize / 2);
          lock.SetY(cy - lockSize / 2);
          lock.SetZ(15);
          lock.SetOpacity(0);

          # Password input bar.
          barImage = Image("line.png").Scale(barWidth, barHeight);
          bar = Sprite(barImage);
          bar.SetX(cx - barWidth / 2);
          bar.SetY(barY);
          bar.SetOpacity(0);

          # Password dots.
          dotImage = Image("bullet.png").Scale(dotSize, dotSize);

          for (i = 0; i < MAX_DOTS; i++) {
            dots[i] = Sprite(dotImage);
            dots[i].SetOpacity(0);
            dots[i].SetZ(20);
          }

          # Show password prompt.
          fun passwordCallback(prompt, count) {
            lock.SetOpacity(1);
            bar.SetOpacity(1);

            if (count > MAX_DOTS) count = MAX_DOTS;

            startX = cx - (count * dotSpacing) / 2
              + (dotSpacing - dotSize) / 2;

            for (i = 0; i < MAX_DOTS; i++) {
              if (i < count) {
                dots[i].SetX(startX + i * dotSpacing);
                dots[i].SetY(dotsY);
                dots[i].SetOpacity(1);
              } else {
                dots[i].SetOpacity(0);
              }
            }
          }

          Plymouth.SetDisplayPasswordFunction(passwordCallback);

          # Hide password prompt.
          fun normalCallback() {
            lock.SetOpacity(0);
            bar.SetOpacity(0);

            for (i = 0; i < MAX_DOTS; i++) {
              dots[i].SetOpacity(0);
            }
          }

          Plymouth.SetDisplayNormalFunction(normalCallback);
          EOF

          runHook postInstall
        '';

        meta = with pkgs.lib; {
          description = "Framework-themed Plymouth boot splash";
          homepage = "https://frame.work";
          license = licenses.mit;
          platforms = platforms.linux;
        };
      };
    };
}
