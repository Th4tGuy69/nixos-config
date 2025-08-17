{ ... }:

let
  midiSource = "M2"; # Your M2 MIDI device name
in

{
  home.file.".config/pipewire/pipewire.conf.d/99-MIDI-auto-connect.conf".text = ''
    # MIDI Auto-connection Configuration
    context.modules = [
      {
        name = libpipewire-module-link-factory
        args = {
          link.rules = [
            {
              matches = [
                {
                  # Match M2 MIDI device output port
                  node.name = "~.*${midiSource}.*"
                  media.class = "Midi/Bridge"
                  port.direction = "out"
                }
              ]
              actions = {
                create-stream = {
                  # Connect to Midi Through port
                  target.object = "Midi-Bridge"
                  target.port.pattern = "Midi Through*"
                  stream.props = {
                    node.autoconnect = true
                    node.dont-reconnect = false
                    node.passive = true
                    media.class = "Midi/Bridge"
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
    
    # Context execution for delayed connection
    context.exec = [
      {
        path = "sh"
        args = [
          "-c" 
          "sleep 2 && pw-link '${midiSource}*:capture_*' 'Midi-Bridge:Midi Through*' 2>/dev/null || true"
        ]
        condition = [ { exec.session-manager = [ ] } ]
      }
    ]
  '';
}
