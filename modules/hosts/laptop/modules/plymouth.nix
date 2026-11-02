{ ... }:

{
  flake.nixosModules.laptopPlymouth =
    { pkgs, ... }:
    let
      framework-svg = pkgs.fetchurl {
        name = "framework.svg";
        url = "https://cdn.simpleicons.org/framework/ffffff";
        hash = "sha256-JolkYApM7VjJgHWfQM4uzBmixQ6lFpjq0aFTom76uvY=";
      };

      lock-svg = pkgs.fetchurl {
        name = "lock-fill.svg";
        url = "https://icons.getbootstrap.com/assets/icons/lock-fill.svg";
        hash = "sha256-j71A/2Hp/ELfRPE50LQJtQG0LRy96fQ/XNXqJc8HswQ=";
      };

      frameworkTheme =
        pkgs.runCommand "framework-plymouth-theme"
          {
            nativeBuildInputs = [
              pkgs.librsvg
              pkgs.imagemagick
            ];
          }
          ''
            d=$out/share/plymouth/themes/framework
            mkdir -p $d

            # spinner: render large, trim margin, pad back to a square
            rsvg-convert -w 512 ${framework-svg} -o raw.png
            sz=$(magick raw.png -trim +repage -format '%[fx:max(w,h)]' info:)
            magick raw.png -trim +repage -background none -gravity center \
              -extent "$sz"x"$sz" $d/spinner.png

            # lock: same treatment (icon uses currentColor, so bake in the grey)
            sed 's/currentColor/#ffffff/' ${lock-svg} > lock.svg
            rsvg-convert -w 256 -h 256 lock.svg -o lock_raw.png
            lsz=$(magick lock_raw.png -trim +repage -format '%[fx:max(w,h)]' info:)
            magick lock_raw.png -trim +repage -background none -gravity center \
              -extent "$lsz"x"$lsz" $d/lock.png

            # large masters, scaled to the display at runtime
            magick -size 64x64 xc:none -fill '#ffffff' -draw 'circle 32,32 32,2' $d/bullet.png
            magick -size 16x16 xc:'#ffffff' $d/line.png

            cat > $d/framework.plymouth <<EOF
            [Plymouth Theme]
            Name=Framework
            Description=Theme based around the Framework logo
            ModuleName=script

            [script]
            ImageDir=$d
            ScriptFile=$d/framework.script
            EOF

            cat > $d/framework.script <<'EOF'
            Window.SetBackgroundTopColor(0.043, 0.043, 0.055);
            Window.SetBackgroundBottomColor(0.043, 0.043, 0.055);

            sw = Window.GetWidth();
            sh = Window.GetHeight();
            cx = sw / 2;
            cy = sh / 2;

            prompting = 0;

            # ---- sizes, all derived from the display ----
            ls   = Math.Int(Math.Min(sw * 0.15, sh * 0.20));  # logo box (1:1)
            lk   = Math.Int(ls * 0.2);                       # lock height, fits inside the ring
            lw   = Math.Int(ls * 0.80);                       # input bar length
            lt   = Math.Max(2, Math.Int(ls * 0.012));         # bar thickness
            MAX  = 8;                                        # dots that fit on the bar
            step = lw / MAX;                                  # dot pitch
            bd   = Math.Int(step * 0.8);                      # dot diameter
            gap1 = Math.Int(ls * 0.35);                       # spinner -> dots
            gap2 = Math.Int(ls * 0.07);                       # dots -> bar

            dots_y = cy + ls / 2 + gap1;
            line_y = dots_y + bd + gap2;

            # ---- spinner: smooth continuous rotation ----
            base = Image("spinner.png").Scale(ls, ls);

            spinner = Sprite(base);
            spinner.SetX(cx - base.GetWidth() / 2);
            spinner.SetY(cy - base.GetHeight() / 2);
            spinner.SetZ(10);

            PI = 3.14159265;

            # Full rotation: 360 degrees.
            FRAMES = 40;

            for (i = 0; i < FRAMES; i++) {
              phase = i / FRAMES;
              frames[i] = base.Rotate(phase * 2 * PI);
            }

            t = 0;

            fun refresh() {
              t++;
              k = t % FRAMES;

              img = frames[k];

              spinner.SetImage(img);
              spinner.SetX(cx - ls / 2);
              spinner.SetY(cy - ls / 2);
            }

            Plymouth.SetRefreshFunction(refresh);

            # ---- lock: center of the screen, inside the ring ----
            lock_img = Image("lock.png").Scale(lk, lk);
            lock = Sprite(lock_img);
            lock.SetX(cx - lk / 2);
            lock.SetY(cy - lk / 2);
            lock.SetZ(15);
            lock.SetOpacity(0);

            # ---- input: bar and dots under the spinner ----
            line_img = Image("line.png").Scale(lw, lt);
            line = Sprite(line_img);
            line.SetX(cx - lw / 2);
            line.SetY(line_y);
            line.SetOpacity(0);

            bullet_img = Image("bullet.png").Scale(bd, bd);
            for (i = 0; i < MAX; i++) {
              bullets[i] = Sprite(bullet_img);
              bullets[i].SetOpacity(0);
              bullets[i].SetZ(20);
            }

            fun password_cb(prompt, count) {
              prompting = 1;
              lock.SetOpacity(1);
              line.SetOpacity(1);
              if (count > MAX) count = MAX;
              x0 = cx - (count * step) / 2 + (step - bd) / 2;
              for (i = 0; i < MAX; i++) {
                if (i < count) {
                  bullets[i].SetX(x0 + i * step);
                  bullets[i].SetY(dots_y);
                  bullets[i].SetOpacity(1);
                } else {
                  bullets[i].SetOpacity(0);
                }
              }
            }
            Plymouth.SetDisplayPasswordFunction(password_cb);

            fun normal_cb() {
              prompting = 0;
              lock.SetOpacity(0);
              line.SetOpacity(0);
              for (i = 0; i < MAX; i++) bullets[i].SetOpacity(0);
            }
            Plymouth.SetDisplayNormalFunction(normal_cb);
            EOF
          '';
    in
    {
      boot.plymouth = {
        enable = true;
        theme = "framework";
        themePackages = [ frameworkTheme ];
      };
    };
}
