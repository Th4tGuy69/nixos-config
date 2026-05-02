{ ... }:

{
  flake.homeModules.music =
    { config, pkgs, ... }:
    let
      soundfonts = with pkgs; [
        soundfont-fluid
        soundfont-arachno
        soundfont-ydp-grand
        soundfont-generaluser
      ];

      sfs = pkgs.runCommandLocal "merge" { inherit soundfonts; } ''
        mkdir -p $out

        ${builtins.concatStringsSep "\n" (
          builtins.map (sf: "ln -s ${sf}/share/soundfonts/* $out/") soundfonts
        )}
      '';

      fluidsynthStartupScript = pkgs.writeText "fluidsynth-startup.scc" (
        builtins.concatStringsSep "\n" (
          builtins.genList (
            channel:
            let
              program = toString (pkgs.lib.mod (channel * 4) 128);
            in
            "select ${toString channel} 0 0 ${program}"
          ) 16
        )
      );
    in
    {
      config = {
        services.fluidsynth = {
          enable = true;
          soundFont = "${config.home.homeDirectory}/.local/share/soundfonts/FluidR3_GM2-2.sf2";
          soundService = "pipewire-pulse";

          extraOptions = [
            "-v"
            "-m"
            "alsa_seq"
            "-o"
            "audio.alsa.device=hw:M2,0"
            "-o"
            "midi.autoconnect=1"
            "-g"
            "1"
            "-f"
            (toString fluidsynthStartupScript)
          ];
        };

        home.packages =
          with pkgs;
          [
            alsa-utils
            qsynth
            synthesia

            reaper
            bitwig-studio

            vital
            cardinal
            helm
            distrho-ports
            dragonfly-reverb
            calf
            talentedhack
            picoloop
            synthv1
            ams
            odin2
            padthv1
            tunefish
            geonkick
            aeolus
            gnaural
            drumkv1
            samplv1
            oxefmsynth
            fire
          ]
          ++ soundfonts;

        home.file.".local/share/soundfonts".source = sfs;

        custom.externalVars = {
          SOUNDFONT_PATH = "${config.home.homeDirectory}/.local/share/soundfonts";
        };
      };
    };
}
