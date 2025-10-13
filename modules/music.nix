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

    ${builtins.concatStringsSep "\n" (builtins.map (sf:
      "ln -s ${sf}/share/soundfonts/* $out/"
    ) soundfonts)}
  '';

  # FluidSynth startup script to assign different instruments to each MIDI channel
  fluidsynthStartupScript = pkgs.writeText "fluidsynth-startup.scc" (builtins.concatStringsSep "\n" (
    builtins.genList (channel:
      let
        program = toString (pkgs.lib.mod (channel * 4) 128);
      in
        "select ${toString channel} 0 0 ${program}"
    ) 16
  ));
in

{
  config = {
    services.fluidsynth = {
      enable = true;
      soundFont = "/home/thatguy/.local/share/soundfonts/FluidR3_GM2-2.sf2";
      soundService = "pipewire-pulse";

      extraOptions = [
        "-v"
        "-m" "alsa_seq"
        "-o" "audio.alsa.device=hw:M2,0"
        "-o" "midi.autoconnect=1"
        "-g" "1"
        "-f" (toString fluidsynthStartupScript)
      ];
    };

    home.packages = with pkgs; [
      # Other Stuff
      alsa-utils
      qsynth
      synthesia
      neothesia
      # sonusmix # Unmaintained :(

      # DAW
      reaper
      # supercollider-with-plugins # Broken (>3.5 CMake)

      # Plugins
      vital
      # surge-XT # Broken (>3.5 CMake)
      cardinal
      helm
      distrho-ports
      # zynaddsubfx # Broken (>3.5 CMake)
      dragonfly-reverb
      calf
      talentedhack
      bristol
      picoloop
      synthv1
      # sorcer # Broken (>3.5 CMake)
      ams
      # ams-lv2 # Broken
      xsynth_dssi
      # opnplug # Broken (>3.5 CMake)
      # adlplug # Broken (>3.5 CMake)
        odin2
      # fmsynth # Unstable
      padthv1
      tunefish
      geonkick
      aeolus
      gnaural
      drumkv1
      # fmtoy # Broken (>3.5 CMake)
      samplv1
      # infamousPlugins # Broken (>3.5 CMake)
      oxefmsynth
      fire
    ] ++ soundfonts;

    home.file.".local/share/soundfonts".source = sfs;

    custom.externalVars = { SOUNDFONT_PATH = "/home/thatguy/.local/share/soundfonts"; };
  };
}
