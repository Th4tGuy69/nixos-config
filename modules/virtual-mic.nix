{ pkgs, ... }:

let
  microphoneSource = "alsa_input.usb-*";
  mixerSinkName = "virtual-mic";
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
              { output = "mic:Out"      input = "mix:In 1" }
              { output = "FSL:Out"    input = "mix:In 2" }
              { output = "FSR:Out"    input = "mix:In 3" }
            ]
            inputs  = [ "mic:In" "FSL:In" "FSR:In" ]
            outputs = [ "mix:Out" ]
          }
          capture.props = {
            node.name = "${microphoneSource}"
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
      
      echo "Starting FluidSynth auto-connect monitor..."
      
      check_and_connect() {
        # Check if both nodes exist
        if ! pw-cli list-objects | grep -q "name.*FluidSynth" || ! pw-cli list-objects | grep -q "Virtual Mic (Mic + Synth)"; then
          return 1
        fi
        
        # Check if connections already exist
        local fl_connected=$(pw-link -l | grep -c "FluidSynth:output_FL.*->.*Virtual Mic:input_2")
        local fr_connected=$(pw-link -l | grep -c "FluidSynth:output_FR.*->.*Virtual Mic:input_3")
        
        # Connect if not already connected
        if [ "$fl_connected" -eq 0 ]; then
          if pw-link "FluidSynth:output_FL" "Virtual Mic (Mic + Synth):input_2" 2>/dev/null; then
            echo "$(date): Connected FluidSynth:output_FL -> Virtual Mic:input_2"
          fi
        fi
        
        if [ "$fr_connected" -eq 0 ]; then
          if pw-link "FluidSynth:output_FR" "Virtual Mic (Mic + Synth):input_3" 2>/dev/null; then
            echo "$(date): Connected FluidSynth:output_FR -> Virtual Mic:input_3"
          fi
        fi
      }
      
      # Monitor loop
      while true; do
        check_and_connect
        sleep 5  # Check every 5 seconds
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
}
