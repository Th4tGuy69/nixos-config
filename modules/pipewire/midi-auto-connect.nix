{ config, lib, pkgs, ... }:

{
  # Udev rule to trigger auto-connect when MIDI device is plugged in
  home.file.".config/udev/rules.d/99-midi-autoconnect.rules" = {
    text = ''
      # Auto-connect M2 MIDI device when plugged in
      # This triggers when any USB MIDI device is added
      SUBSYSTEM=="sound", KERNEL=="midiC*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="midi-hotplug-connect.service"
      
      # Alternative: More specific rule for your M2 device (if you know vendor/product IDs)
      # Find with: lsusb | grep -i midi
      # SUBSYSTEM=="usb", ATTRS{idVendor}=="XXXX", ATTRS{idProduct}=="YYYY", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}="midi-hotplug-connect.service"
    '';
  };

  # Systemd service that runs when MIDI device is plugged in
  systemd.user.services.midi-hotplug-connect = {
    Unit = {
      Description = "Auto-connect MIDI device when plugged in";
      After = [ "sound.target" ];
    };
    
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.local/bin/midi-hotplug-handler";
      # Don't fail the service if connection fails
      SuccessExitStatus = [ 0 1 ];
    };
    
    # Don't install - triggered by udev
    Install = { };
  };

  # Advanced hotplug handler with retry logic
  home.file.".local/bin/midi-hotplug-handler" = {
    text = ''
      #!/usr/bin/env bash
      
      # MIDI Hotplug Connection Handler
      echo "$(date): MIDI hotplug event detected" >> "$HOME/.local/log/midi-autoconnect.log"
      
      # Wait for device to be fully initialized
      sleep 3
      
      # Function to attempt connection
      try_connect() {
        local attempt=$1
        echo "$(date): Connection attempt $attempt" >> "$HOME/.local/log/midi-autoconnect.log"
        
        # Check if M2 device is available
        if ! aconnect -l 2>/dev/null | grep -q "M2"; then
          echo "$(date): M2 device not found in attempt $attempt" >> "$HOME/.local/log/midi-autoconnect.log"
          return 1
        fi
        
        # Check if Midi Through is available
        if ! aconnect -l 2>/dev/null | grep -q "Midi Through"; then
          echo "$(date): Midi Through not found in attempt $attempt" >> "$HOME/.local/log/midi-autoconnect.log"
          return 1
        fi
        
        # Get actual client IDs (they might change)
        local m2_client=$(aconnect -l 2>/dev/null | grep "M2" | head -1 | grep -o "client [0-9]*" | grep -o "[0-9]*")
        local through_client=$(aconnect -l 2>/dev/null | grep "Midi Through" | head -1 | grep -o "client [0-9]*" | grep -o "[0-9]*")
        
        if [ -n "$m2_client" ] && [ -n "$through_client" ]; then
          echo "$(date): Found M2 client $m2_client, Through client $through_client" >> "$HOME/.local/log/midi-autoconnect.log"
          
          # Attempt connection
          if aconnect "$m2_client:0" "$through_client:0" 2>/dev/null; then
            echo "$(date): ✓ Successfully connected $m2_client:0 to $through_client:0" >> "$HOME/.local/log/midi-autoconnect.log"
            
            # Send notification if available
            if command -v notify-send >/dev/null 2>&1; then
              notify-send "MIDI Connected" "M2 device auto-connected to Midi Through"
            fi
            
            return 0
          else
            echo "$(date): ✗ Connection failed: $m2_client:0 -> $through_client:0" >> "$HOME/.local/log/midi-autoconnect.log"
            return 1
          fi
        else
          echo "$(date): Could not determine client IDs" >> "$HOME/.local/log/midi-autoconnect.log"
          return 1
        fi
      }
      
      # Create log directory
      mkdir -p "$HOME/.local/log"
      
      # Try connection with retries
      max_attempts=5
      for i in $(seq 1 $max_attempts); do
        if try_connect $i; then
          echo "$(date): Connection successful on attempt $i" >> "$HOME/.local/log/midi-autoconnect.log"
          exit 0
        fi
        
        if [ $i -lt $max_attempts ]; then
          echo "$(date): Waiting 2 seconds before retry..." >> "$HOME/.local/log/midi-autoconnect.log"
          sleep 2
        fi
      done
      
      echo "$(date): All connection attempts failed" >> "$HOME/.local/log/midi-autoconnect.log"
      exit 1
    '';
    executable = true;
  };

  # Alternative: Polling-based solution (more reliable but uses more resources)
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

  # Polling daemon that checks for MIDI device periodically
  home.file.".local/bin/midi-monitor-daemon" = {
    text = ''
      #!/usr/bin/env bash
      
      # MIDI Connection Monitor Daemon
      echo "Starting MIDI connection monitor daemon..."
      
      # Track connection state
      connected=false
      
      while true; do
        # Check if M2 device is present
        if aconnect -l 2>/dev/null | grep -q "M2"; then
          # Check if it's already connected to Midi Through
          m2_client=$(aconnect -l 2>/dev/null | grep "M2" | head -1 | grep -o "client [0-9]*" | grep -o "[0-9]*")
          
          if [ -n "$m2_client" ]; then
            # Check if connection exists
            if aconnect -l 2>/dev/null | grep -A10 "client $m2_client" | grep -q "14:0"; then
              if [ "$connected" = false ]; then
                echo "$(date): M2 device is connected to Midi Through"
                connected=true
              fi
            else
              # Device present but not connected - try to connect
              if [ "$connected" = true ]; then
                echo "$(date): M2 device disconnected, attempting reconnection..."
                connected=false
              fi
              
              echo "$(date): Attempting to connect M2 device..."
              if aconnect "$m2_client:0" "14:0" 2>/dev/null; then
                echo "$(date): ✓ Connected M2 to Midi Through"
                connected=true
                
                # Send notification
                if command -v notify-send >/dev/null 2>&1; then
                  notify-send "MIDI Connected" "M2 device auto-connected to Midi Through"
                fi
              else
                echo "$(date): ✗ Failed to connect M2 device"
              fi
            fi
          fi
        else
          # Device not present
          if [ "$connected" = true ]; then
            echo "$(date): M2 device disconnected"
            connected=false
          fi
        fi
        
        # Wait before next check
        sleep 5
      done
    '';
    executable = true;
  };

  # Manual connection/disconnection scripts
  home.file.".local/bin/midi-connect" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "Manual MIDI Connection"
      echo "====================="
      
      # Find M2 device
      m2_client=$(aconnect -l 2>/dev/null | grep "M2" | head -1 | grep -o "client [0-9]*" | grep -o "[0-9]*")
      
      if [ -z "$m2_client" ]; then
        echo "✗ M2 device not found. Available devices:"
        aconnect -l | grep -E "client [0-9]+:"
        exit 1
      fi
      
      echo "Found M2 device on client $m2_client"
      
      # Connect to Midi Through
      if aconnect "$m2_client:0" "14:0" 2>/dev/null; then
        echo "✓ Connected M2 ($m2_client:0) to Midi Through (14:0)"
        
        # Verify connection
        if aconnect -l | grep -A5 "client $m2_client" | grep -q "14:0"; then
          echo "✓ Connection verified"
        fi
      else
        echo "✗ Connection failed"
        echo "Make sure Midi Through port exists:"
        aconnect -l | grep -i through
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/midi-disconnect" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "Manual MIDI Disconnection"
      echo "========================"
      
      # Find M2 device
      m2_client=$(aconnect -l 2>/dev/null | grep "M2" | head -1 | grep -o "client [0-9]*" | grep -o "[0-9]*")
      
      if [ -n "$m2_client" ]; then
        if aconnect -d "$m2_client:0" "14:0" 2>/dev/null; then
          echo "✓ Disconnected M2 ($m2_client:0) from Midi Through (14:0)"
        else
          echo "✗ Disconnection failed (may not have been connected)"
        fi
      else
        echo "M2 device not found"
      fi
    '';
    executable = true;
  };

  # Status checking script
  home.file.".local/bin/midi-status" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "MIDI Connection Status"
      echo "====================="
      
      # Check if M2 device exists
      m2_client=$(aconnect -l 2>/dev/null | grep "M2" | head -1 | grep -o "client [0-9]*" | grep -o "[0-9]*")
      
      if [ -n "$m2_client" ]; then
        echo "✓ M2 device found (client $m2_client)"
        
        # Check connection status
        if aconnect -l | grep -A10 "client $m2_client" | grep -q "14:0"; then
          echo "✓ M2 is connected to Midi Through"
          echo
          echo "Test with: aseqdump -p 14:0"
        else
          echo "✗ M2 is NOT connected to Midi Through"
          echo
          echo "Connect with: ~/.local/bin/midi-connect"
        fi
      else
        echo "✗ M2 device not found"
        echo
        echo "Available MIDI devices:"
        aconnect -l | grep -E "client [0-9]+.*type=kernel"
      fi
      
      # Show log if exists
      if [ -f "$HOME/.local/log/midi-autoconnect.log" ]; then
        echo
        echo "Recent auto-connect log:"
        tail -5 "$HOME/.local/log/midi-autoconnect.log"
      fi
    '';
    executable = true;
  };

  # Install notification support
  home.packages = with pkgs; [
    libnotify  # for notify-send
    alsa-utils
  ];
}
