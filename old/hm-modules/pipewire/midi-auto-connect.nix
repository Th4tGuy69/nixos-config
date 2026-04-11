{ config, lib, pkgs, ... }:

{
  # Simple polling daemon for MIDI auto-connect
  systemd.user.services.midi-connection-monitor = {
    Unit = {
      Description = "Monitor for MIDI device and auto-connect";
      After = [ "pipewire.service" ];
    };
    
    Service = {
      Type = "simple";
      ExecStart = "${config.home.homeDirectory}/.local/bin/midi-monitor-daemon";
      Restart = "always";
      RestartSec = "10s";
    };
    
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Crash-safe polling daemon
  home.file.".local/bin/midi-monitor-daemon" = {
    text = ''
      #!/usr/bin/env bash
      
      # MIDI Connection Monitor Daemon (PipeWire-crash-safe version)
      echo "Starting crash-safe MIDI connection monitor daemon..."
      
      # Track connection state
      connected=false
      check_interval=10  # Check every 10 seconds to reduce crash risk
      
      # Create log directory
      mkdir -p "$HOME/.local/log"
      echo "$(date): Starting crash-safe MIDI monitor" >> "$HOME/.local/log/midi-safe.log"
      
      while true; do
        # Use /proc/asound to check for MIDI devices instead of aconnect -l
        # This avoids triggering PipeWire's ALSA sequencer bridge
        
        # Check if M2 card exists
        if [ -d "/proc/asound/card2" ] && [ -f "/proc/asound/card2/midi0" ]; then
          if [ "$connected" = false ]; then
            echo "$(date): M2 device detected via /proc/asound" >> "$HOME/.local/log/midi-safe.log"
            
            # Get M2 client ID from /proc
            m2_client=$(grep -E "Client.*M2" /proc/asound/seq/clients 2>/dev/null | head -1 | grep -o "Client *[0-9]*" | grep -o "[0-9]*")
            
            if [ -n "$m2_client" ]; then
              echo "$(date): Found M2 client ID: $m2_client" >> "$HOME/.local/log/midi-safe.log"
              
              # Try connection (this may cause PipeWire crash, but we minimize frequency)
              if timeout 5s aconnect "$m2_client:0" "14:0" 2>/dev/null; then
                echo "$(date): ✓ Connected M2 to Midi Through" >> "$HOME/.local/log/midi-safe.log"
                connected=true
                
                # Send notification
                if command -v notify-send >/dev/null 2>&1; then
                  notify-send "MIDI Connected" "M2 device auto-connected"
                fi
              else
                echo "$(date): ✗ Connection attempt failed" >> "$HOME/.local/log/midi-safe.log"
              fi
            fi
          fi
        else
          # Device not present
          if [ "$connected" = true ]; then
            echo "$(date): M2 device disconnected" >> "$HOME/.local/log/midi-safe.log"
            connected=false
          fi
        fi
        
        # Sleep to reduce crash risk
        sleep $check_interval
      done
    '';
    executable = true;
  };

  # Install required packages
  home.packages = with pkgs; [
    libnotify  # for notify-send
    alsa-utils  # for aconnect
  ];
}
