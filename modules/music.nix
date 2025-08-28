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
      sonusmix

      # DAW
      reaper
      supercollider-with-plugins

      # Plugins
      vital
      surge-XT
      cardinal
      helm
      distrho-ports
      zynaddsubfx
      dragonfly-reverb
      calf
      talentedhack
      bristol
      picoloop
      synthv1
      sorcer
      ams
      # ams-lv2 # Broken
      xsynth_dssi
      opnplug
      adlplug
      odin2
      # fmsynth # Unstable
      padthv1
      tunefish
      geonkick
      aeolus
      gnaural
      drumkv1
      fmtoy
      samplv1
      infamousPlugins
      oxefmsynth
      fire
    ] ++ soundfonts;

    home.file.".local/share/soundfonts".source = sfs;

    custom.externalVars = { SOUNDFONT_PATH = "/home/thatguy/.local/share/soundfonts"; };
  };
}
