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
in

{
  imports = [
    (import ./virtual-mic.nix {
      pkgs = pkgs;
      microphoneSource = "alsa_input.usb-MOTU_M2_M2AE1529VI-00.HiFi__Mic1__source";
      mixerSinkName = "FluidSynth + Mic";
    })
  ];

  config = {
    services.fluidsynth = {
      enable = true;
      soundFont = "/home/thatguy/.local/share/soundfonts/FluidR3_GM2-2.sf2";
      soundService = "pipewire-pulse";

      extraOptions = [
        "-v"
        "-m" "alsa_raw"
        "-o" "audio.alsa.device=hw:M2,0"
        "-o" "midi.alsa.device=hw:M2,0"
        "-g" "1"
      ];
    };

    home.packages = with pkgs; [
      # Other Stuff
      alsa-utils
      qsynth
      synthesia
      neothesia
    
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
    ] ++ soundfonts;

    home.file.".local/share/soundfonts".source = sfs;

    custom.externalVars = { SOUNDFONT_PATH = "/home/thatguy/.local/share/soundfonts"; };
  };
}
