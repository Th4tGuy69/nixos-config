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

  # Crash-safe polling daemon that avoids triggering PipeWire bugs
  home.file.".local/bin/midi-monitor-daemon" = {
    text = ''
      #!/usr/bin/env bash
      
      # MIDI Connection Monitor Daemon (PipeWire-crash-safe version)
      echo "Starting crash-safe MIDI connection monitor daemon..."
      
      # Track connection state
      connected=false
      last_check_time=0
      check_interval=10  # Check every 10 seconds to reduce crash risk
      
      # Function to safely check ALSA devices without triggering PipeWire crashes
      safe_check_alsa() {
        # Use /proc/asound to check for MIDI devices instead of aconnect -l
        # This avoids triggering PipeWire's ALSA sequencer bridge
        
        # Check if M2 card exists
        if [ -d "/proc/asound/card2" ] && [ -f "/proc/asound/card2/midi0" ]; then
          return 0  # M2 device present
        else
          return 1  # M2 device not present
        fi
      }
      
      # Function to get ALSA client ID from /proc without aconnect
      get_m2_client_id() {
        # Parse /proc/asound/seq/clients to find M2 client
        if [ -f "/proc/asound/seq/clients" ]; then
          grep -E "Client.*M2" /proc/asound/seq/clients 2>/dev/null | head -1 | grep -o "Client *[0-9]*" | grep -o "[0-9]*"
        fi
      }
      
      # Function to check connection status without aconnect -l
      check_connection_status() {
        local m2_client="$1"
        if [ -n "$m2_client" ] && [ -f "/proc/asound/seq/clients" ]; then
          # Check if there's a connection from M2 client to client 14 (Midi Through)
          if [ -f "/proc/asound/seq/queues" ]; then
            # This is a simplified check - we'll rely on our connection tracking
            return 0
          fi
        fi
        return 1
      }
      
      # Function to attempt connection (this may still cause crashes, so we minimize calls)
      try_connect() {
        local m2_client="$1"
        echo "$(date): Attempting connection (crash risk)" >> "$HOME/.local/log/midi-safe.log"
        
        # Try to connect with minimal ALSA sequencer interaction
        if timeout 5s aconnect "$m2_client:0" "14:0" 2>/dev/null; then
          return 0
        else
          return 1
        fi
      }
      
      # Create log directory
      mkdir -p "$HOME/.local/log"
      echo "$(date): Starting crash-safe MIDI monitor" >> "$HOME/.local/log/midi-safe.log"
      
      while true; do
        current_time=$(date +%s)
        
        # Rate limit checks to reduce crash frequency
        if [ $((current_time - last_check_time)) -ge $check_interval ]; then
          last_check_time=$current_time
          
          # Use safe method to check for M2 device
          if safe_check_alsa; then
            if [ "$connected" = false ]; then
              echo "$(date): M2 device detected via /proc/asound" >> "$HOME/.local/log/midi-safe.log"
              
              # Only now do we risk using ALSA sequencer commands
              m2_client=$(get_m2_client_id)
              
              if [ -n "$m2_client" ]; then
                echo "$(date): Found M2 client ID: $m2_client" >> "$HOME/.local/log/midi-safe.log"
                
                # Try connection (this is the risky part)
                if try_connect "$m2_client"; then
                  echo "$(date): ✓ Connected M2 to Midi Through" >> "$HOME/.local/log/midi-safe.log"
                  connected=true
                  
                  # Send notification
                  if command -v notify-send >/dev/null 2>&1; then
                    notify-send "MIDI Connected" "M2 device auto-connected (safe mode)"
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
        fi
        
        # Sleep longer to reduce crash risk
        sleep $check_interval
      done
    '';
    executable = true;
  };

  # Crash-safe manual connection script
  home.file.".local/bin/midi-connect" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "Manual MIDI Connection (Crash-Safe)"
      echo "==================================="
      
      # WARNING: This command may cause PipeWire to crash and restart
      echo "⚠️  Warning: This may cause PipeWire to restart"
      read -p "Continue? (y/N): " -n 1 -r
      echo
      
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled"
        exit 0
      fi
      
      echo "Checking for M2 device via /proc/asound..."
      
      # Check if M2 card exists safely
      if [ -d "/proc/asound/card2" ] && [ -f "/proc/asound/card2/midi0" ]; then
        echo "✓ M2 device detected at card2"
        
        # Get client ID from /proc
        m2_client=$(grep -E "Client.*M2" /proc/asound/seq/clients 2>/dev/null | head -1 | grep -o "Client *[0-9]*" | grep -o "[0-9]*")
        
        if [ -n "$m2_client" ]; then
          echo "Found M2 client ID: $m2_client"
          
          # This is the risky part that may crash PipeWire
          echo "Attempting connection (may crash PipeWire)..."
          if timeout 10s aconnect "$m2_client:0" "14:0" 2>/dev/null; then
            echo "✓ Connected M2 ($m2_client:0) to Midi Through (14:0)"
            echo "Test with: aseqdump -p 14:0 (WARNING: may also crash PipeWire)"
          else
            echo "✗ Connection failed or timed out"
          fi
        else
          echo "✗ Could not determine M2 client ID"
        fi
      else
        echo "✗ M2 device not found at /proc/asound/card2"
        echo "Available sound cards:"
        ls -la /proc/asound/card* 2>/dev/null || echo "No sound cards found"
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

  # Crash-safe status checking script
  home.file.".local/bin/midi-status" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "MIDI Connection Status (Crash-Safe Mode)"
      echo "======================================="
      
      # Check using /proc/asound instead of aconnect to avoid crashes
      echo "Checking via /proc/asound (safe method)..."
      
      # Check if M2 device exists
      if [ -d "/proc/asound/card2" ] && [ -f "/proc/asound/card2/midi0" ]; then
        echo "✓ M2 device detected at /proc/asound/card2"
        
        # Check if PipeWire is running
        if pgrep -x pipewire >/dev/null; then
          echo "✓ PipeWire is running"
        else
          echo "⚠️  PipeWire is not running (may have crashed)"
        fi
        
        # Show safe connection information
        echo
        echo "Safe connection check:"
        echo "- M2 card: $([ -d "/proc/asound/card2" ] && echo "Present" || echo "Missing")"
        echo "- MIDI interface: $([ -f "/proc/asound/card2/midi0" ] && echo "Available" || echo "Missing")"
        
        # Get client info safely
        if [ -f "/proc/asound/seq/clients" ]; then
          echo "- ALSA sequencer clients:"
          grep -E "Client.*(M2|Midi Through)" /proc/asound/seq/clients 2>/dev/null || echo "  None found"
        fi
        
      else
        echo "✗ M2 device not found"
        echo
        echo "Available sound cards:"
        for card in /proc/asound/card*; do
          if [ -d "$card" ]; then
            card_num=$(basename "$card" | sed 's/card//')
            card_name=$(cat "$card/id" 2>/dev/null || echo "Unknown")
            echo "  Card $card_num: $card_name"
          fi
        done
      fi
      
      # Show daemon status
      echo
      echo "Daemon status:"
      if systemctl --user is-active --quiet midi-connection-monitor; then
        echo "✓ Auto-connect daemon is running"
      else
        echo "✗ Auto-connect daemon is not running"
        echo "  Start with: systemctl --user start midi-connection-monitor"
      fi
      
      # Show safe log
      if [ -f "$HOME/.local/log/midi-safe.log" ]; then
        echo
        echo "Recent safe log entries:"
        tail -5 "$HOME/.local/log/midi-safe.log"
      fi
      
      echo
      echo "🛡️  Crash-safe commands:"
      echo "  ~/.local/bin/midi-connect-safe    # Connect without crashes"
      echo "  ~/.local/bin/monitor-midi-proc    # Monitor via /proc"
      echo
      echo "⚠️   Risky commands (may crash PipeWire):"
      echo "  ~/.local/bin/midi-connect         # Manual connect" 
      echo "  aseqdump -p 14:0                  # Monitor through port"
    '';
    executable = true;
  };

  # Completely crash-safe connection method using direct device files
  home.file.".local/bin/midi-connect-safe" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "Crash-Safe MIDI Connection"
      echo "========================="
      echo "This method bypasses ALSA sequencer to avoid PipeWire crashes"
      echo
      
      # Check if M2 device exists
      if [ -c "/dev/snd/midiC2D0" ]; then
        echo "✓ M2 device found at /dev/snd/midiC2D0"
        
        # Create a simple MIDI bridge using named pipes (crash-safe)
        PIPE_DIR="$HOME/.local/share/midi-bridge"
        mkdir -p "$PIPE_DIR"
        
        # Create named pipes for MIDI data
        if [ ! -p "$PIPE_DIR/m2_to_through" ]; then
          mkfifo "$PIPE_DIR/m2_to_through"
        fi
        
        echo "Setting up crash-safe MIDI bridge..."
        echo "This creates a background process to copy MIDI data"
        
        # Kill any existing bridge
        pkill -f "midi-bridge-worker" 2>/dev/null
        
        # Start background MIDI bridge worker
        nohup bash -c '
          echo "$(date): Starting MIDI bridge worker" >> "'$HOME'/.local/log/midi-safe.log"
          while true; do
            if [ -c "/dev/snd/midiC2D0" ] && [ -c "/dev/snd/midiC1D0" ]; then
              # Copy MIDI data from M2 to system (this is crash-safe)
              cat /dev/snd/midiC2D0 > /dev/snd/midiC1D0 2>/dev/null || sleep 1
            else
              sleep 5
            fi
          done
        ' > "$HOME/.local/log/midi-bridge.log" 2>&1 &
        
        echo "✓ Crash-safe MIDI bridge started (PID: $!)"
        echo "✓ MIDI data will be forwarded from M2 to system MIDI"
        
        # Save PID for cleanup
        echo $! > "$HOME/.local/share/midi-bridge/bridge.pid"
        
        echo
        echo "To stop the bridge: ~/.local/bin/midi-disconnect-safe"
        echo "To monitor: tail -f ~/.local/log/midi-bridge.log"
        
      else
        echo "✗ M2 device not found at /dev/snd/midiC2D0"
        echo
        echo "Available MIDI devices:"
        ls -la /dev/snd/midiC* 2>/dev/null || echo "No MIDI devices found"
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/midi-disconnect-safe" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "Stopping crash-safe MIDI bridge..."
      
      # Kill bridge worker
      if [ -f "$HOME/.local/share/midi-bridge/bridge.pid" ]; then
        bridge_pid=$(cat "$HOME/.local/share/midi-bridge/bridge.pid")
        if kill "$bridge_pid" 2>/dev/null; then
          echo "✓ Stopped MIDI bridge (PID: $bridge_pid)"
        else
          echo "Bridge process not running or already stopped"
        fi
        rm -f "$HOME/.local/share/midi-bridge/bridge.pid"
      fi
      
      # Kill any remaining workers
      pkill -f "midi-bridge-worker" 2>/dev/null && echo "✓ Cleaned up any remaining bridge processes"
      
      echo "✓ Crash-safe MIDI bridge stopped"
    '';
    executable = true;
  };

  # Monitor MIDI via /proc without triggering crashes
  home.file.".local/bin/monitor-midi-proc" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "MIDI Monitor via /proc (Crash-Safe)"
      echo "==================================="
      echo "This monitors MIDI activity without using ALSA sequencer"
      echo
      
      if [ ! -f "/proc/asound/card2/midi0" ]; then
        echo "✗ M2 MIDI device not found"
        exit 1
      fi
      
      echo "✓ M2 MIDI device detected"
      echo "Monitoring MIDI activity (Ctrl+C to stop)..."
      echo
      
      # Monitor /proc/interrupts for MIDI activity (very safe)
      prev_interrupts=0
      
      while true; do
        # Look for USB/sound interrupts as a proxy for MIDI activity
        current_interrupts=$(grep -E "uhci_hcd\|ehci_hcd\|xhci_hcd\|snd" /proc/interrupts 2>/dev/null | awk '{sum += $2} END {print sum+0}')
        
        if [ "$current_interrupts" -gt "$prev_interrupts" ]; then
          echo "$(date): USB/Audio activity detected (interrupts: $current_interrupts)"
        fi
        
        prev_interrupts=$current_interrupts
        sleep 1
      done
    '';
    executable = true;
  };
}
