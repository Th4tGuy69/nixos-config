{ pkgs, ... }:

let
  microphoneSource = "alsa_input.usb-MOTU_M2_M2AE1529VI-00.HiFi__Mic1__source";
  mixerSinkName = "FluidSynth + Mic";
in

{
  home.file.".config/pipewire/pipewire.conf.d/99-virtual-mic.conf".text = ''
    context.modules = [
      {
        name = libpipewire-module-filter-chain
        args = {
          node.name = "${mixerSinkName}"
          node.description = "Virtual Mic"
          filter.graph = {
            nodes = [
              { type = builtin label = copy  name = mic }
              { type = builtin label = copy  name = FSL }
              { type = builtin label = copy  name = FSR }
              { type = builtin label = mixer name = mix control = {
                "1" = 1.0  # Mic
                "2" = 0.5  # Synth L
                "3" = 0.5  # Synth R
              }}
            ]
            links = [
              { output = "mic:Out" input = "mix:In 1" }
              { output = "FSL:Out" input = "mix:In 2" }
              { output = "FSR:Out" input = "mix:In 3" }
            ]
            inputs  = [ "mic:In" "FSL:In" "FSR:In" ]
            outputs = [ "mix:Out" ]
          }
          capture.props = {
            node.name = "Virtual Mic"
            target.node = "${microphoneSource}"
            stream.dont-remix = true
          }
          playback.props = {
            node.description = "Virtual Mic"
            media.class = "Audio/Source"
            audio.channels = 1
            stream.dont-remix = true
          }
        }
      }
    ]
  '';

  # Monitoring script to continuously auto-connect FluidSynth
  home.file.".local/bin/connect-fluidsynth.sh" = {
    text = ''
      #!/usr/bin/env bash

      ECHO="${pkgs.coreutils}/bin/echo"
      SLEEP="${pkgs.coreutils}/bin/sleep"
      GREP="${pkgs.gnugrep}/bin/grep"
      PW_CLI="${pkgs.pipewire}/bin/pw-cli"
      PW_LINK="${pkgs.pipewire}/bin/pw-link"

      $ECHO "Starting FluidSynth auto-connect monitor..."

      check_and_connect() {
        if ! $PW_CLI list-objects | $GREP -q "name.*FluidSynth" || ! $PW_CLI list-objects | $GREP -q "Virtual Mic"; then
          return 1
        fi

        local fl_connected=$($PW_LINK -l | $GREP -c "FluidSynth:output_FL.*->.*Virtual Mic:input_2")
        local fr_connected=$($PW_LINK -l | $GREP -c "FluidSynth:output_FR.*->.*Virtual Mic:input_3")

        if [ "$fl_connected" -eq 0 ]; then
          if $PW_LINK "FluidSynth:output_FL" "Virtual Mic:input_2" 2>/dev/null; then
            $ECHO "$($coreutils)/bin/date): Connected FluidSynth:output_FL -> Virtual Mic:input_2"
          fi
        fi

        if [ "$fr_connected" -eq 0 ]; then
          if $PW_LINK "FluidSynth:output_FR" "Virtual Mic:input_3" 2>/dev/null; then
            $ECHO "$($coreutils)/bin/date): Connected FluidSynth:output_FR -> Virtual Mic:input_3"
          fi
        fi
      }

      while true; do
        check_and_connect
        $SLEEP 5
      done
    '';
    executable = true;
  };

  # Systemd service to monitor and auto-connect FluidSynth
  systemd.user.services.fluidsynth-autoconnect = {
    Unit = {
      Description = "Auto-connect FluidSynth to Virtual Mic";
      After = [ "pipewire.service" ];
      Wants = [ "pipewire.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash %h/.local/bin/connect-fluidsynth.sh";
      Restart = "always";
      RestartSec = "10";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Packages required for the service
  home.packages = with pkgs; [
    pipewire # pw-cli
    coreutils # sleep
    gnugrep # grep
  ];
}
