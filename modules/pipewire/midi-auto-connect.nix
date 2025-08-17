{ ... }:

let
  # Replace this with your actual MIDI device name or pattern
  # You can find it by running: pw-cli list-objects | grep -A5 -B5 "midi"
  # or by looking in Helvum for your device's exact name
  midiSource = "M2 MIDI 1 (capture)";
in

{
  home.file.".config/pipewire/pipewire.conf.d/99-MIDI-auto-connect.conf".text = ''
    # Auto-connect MIDI device to Midi Through port
    context.exec = [
      {
        path = "pactl"
        args = "load-module module-combine-sink"
        condition = [ { exec.session-manager = [ ] } ]
      }
    ]

    context.modules = [
      {
        name = libpipewire-module-link-factory
        args = {
          link.rules = [
            {
              matches = [
                {
                  # Match your MIDI device's output port
                  node.name = "~${midiSource}.*"
                  media.class = "Midi/Bridge"
                  port.direction = "out"
                }
              ]
              actions = {
                create-stream = {
                  # Connect to Midi-Bridge Midi Through port
                  target.object = "Midi-Bridge"
                  target.port.pattern = "Midi Through:*"
                  stream.props = {
                    node.autoconnect = true
                    node.dont-reconnect = false
                  }
                }
              }
            }
          ]
        }
      }
    ]

    # Alternative method using session manager rules
    session.suspend-timeout-seconds = 0

    wireplumber.rules = [
      {
        matches = [
          {
            node.name = "~${midiSource}.*"
            media.class = "Midi/Bridge"
          }
        ]
        actions = {
          update-props = {
            node.autoconnect = true
            target.object = "Midi-Bridge"
          }
        }
      }
    ]
  '';

  # Optional: Also create a simple script for manual connection
  home.file.".local/bin/connect-midi-through" = {
    text = ''
      #!/usr/bin/env bash
      # Manual MIDI connection script
      
      # Find your MIDI device
      DEVICE_PORT=$(pw-cli list-objects | grep -A10 "${midiSource}" | grep "port\.name.*out" | head -1 | cut -d'"' -f4)
      
      # Find Midi Through input port
      THROUGH_PORT=$(pw-cli list-objects | grep -A10 "Midi-Bridge" | grep -A5 "Midi Through" | grep "port\.name.*in" | head -1 | cut -d'"' -f4)
      
      if [ -n "$DEVICE_PORT" ] && [ -n "$THROUGH_PORT" ]; then
        echo "Connecting $DEVICE_PORT to $THROUGH_PORT"
        pw-link "$DEVICE_PORT" "$THROUGH_PORT"
      else
        echo "Could not find MIDI ports"
        echo "Available MIDI devices:"
        pw-cli list-objects | grep -A5 -B5 "Midi"
      fi
    '';
    executable = true;
  };
}
