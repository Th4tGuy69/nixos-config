{ config, pkgs, ... }:

{
  # Enable ALSA MIDI bridging in PipeWire
  home.file.".config/pipewire/pipewire.conf.d/10-alsa-midi-bridge.conf".text = ''
    # Enable ALSA MIDI bridge
    context.modules = [
      {
        name = libpipewire-module-adapter
        args = {
          factory.name     = api.alsa.seq.bridge
          node.name        = "Midi-Bridge"
          node.description = "MIDI Bridge"
          media.class      = "Midi/Bridge"
          api.alsa.path    = "hw:2"  # Your M2 device is on card 2
          api.alsa.seq.server = "default"
          api.alsa.seq.id = "PipeWire-MIDI"
        }
      }
    ]
  '';

  # Alternative method: Enable via WirePlumber ALSA monitor
  home.file.".config/wireplumber/main.lua.d/10-alsa-midi-enable.lua".text = ''
    -- Enable ALSA MIDI monitoring and bridging
    alsa_monitor.enabled = true
    alsa_monitor.properties = {
      -- Enable MIDI bridging
      ["alsa.seq.enabled"] = true,
      ["alsa.seq.server"] = "default",
      
      -- Monitor your specific card
      ["api.alsa.card"] = "2",  -- Your M2 device
      ["api.alsa.path"] = "hw:2",
      
      -- Bridge settings
      ["node.nick"] = "ALSA-MIDI",
      ["priority.driver"] = 100,
      ["priority.session"] = 100,
    }
    
    -- Add rule to automatically expose MIDI devices
    midi_bridge_rule = {
      matches = {
        {
          { "api.alsa.card", "equals", "2" },
        },
      },
      apply_properties = {
        ["node.autoconnect"] = false,  -- We'll handle this manually
        ["media.class"] = "Midi/Bridge",
        ["api.alsa.seq.enabled"] = true,
      },
    }
    
    table.insert(alsa_monitor.rules, midi_bridge_rule)
  '';

  # Updated auto-connect configuration that works with ALSA client IDs
  home.file.".config/pipewire/pipewire.conf.d/99-MIDI-auto-connect.conf".text = ''
    # MIDI Auto-connection using ALSA bridge
    context.exec = [
      {
        path = "sh"
        args = [
          "-c"
          "sleep 3 && ${config.home.homeDirectory}/.local/bin/alsa-midi-autoconnect"
        ]
        condition = [ { exec.session-manager = [ ] } ]
      }
    ]
  '';

  # Simple ALSA-based auto-connect script (more reliable)
  home.file.".local/bin/alsa-midi-autoconnect" = {
    text = ''
      #!/usr/bin/env bash
      
      # Wait for ALSA sequencer to be ready
      sleep 2
      
      # Check if devices exist
      if ! aconnect -l | grep -q "24:.*M2"; then
        echo "M2 device (24) not found"
        exit 1
      fi
      
      if ! aconnect -l | grep -q "14:.*Midi Through"; then
        echo "Midi Through (14) not found" 
        exit 1
      fi
      
      # Connect M2 output to Midi Through input
      if aconnect 24:0 14:0 2>/dev/null; then
        echo "✓ Auto-connected M2 (24:0) to Midi Through (14:0)"
        
        # Verify connection
        if aconnect -l | grep -A5 "client 24" | grep -q "14:0"; then
          echo "✓ Connection verified"
        else
          echo "✗ Connection verification failed"
        fi
      else
        echo "✗ Failed to auto-connect M2 to Midi Through"
      fi
      
      # Log current connections
      echo "Current MIDI connections:"
      aconnect -l | grep -A10 "client 24\|client 14"
    '';
    executable = true;
  };

  # Systemd service to run auto-connect after boot
  systemd.user.services.alsa-midi-autoconnect = {
    Unit = {
      Description = "Auto-connect ALSA MIDI devices";
      After = [ "pipewire.service" "sound.target" ];
      Wants = [ "pipewire.service" ];
    };
    
    Service = {
      Type = "oneshot";
      ExecStart = "${config.home.homeDirectory}/.local/bin/alsa-midi-autoconnect";
      RemainAfterExit = true;
      # Restart if it fails (device might not be ready yet)
      Restart = "on-failure";
      RestartSec = "5s";
    };
    
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Better monitoring script that works with your setup
  home.file.".local/bin/monitor-midi-m2" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "M2 MIDI Monitor"
      echo "==============="
      
      # Show current connections
      echo "Current ALSA MIDI connections:"
      aconnect -l | grep -A5 -B5 "M2\|Midi Through"
      echo
      
      # Option 1: Monitor M2 directly (works)
      echo "1) Monitor M2 device directly (24:0)"
      echo "2) Monitor Midi Through port (14:0) - should show data if connected"
      echo "3) Show connection status"
      echo "4) Test connection"
      echo
      read -p "Choose option (1-4): " choice
      
      case $choice in
        1)
          echo "Monitoring M2 directly - play some notes:"
          aseqdump -p 24:0 2>/dev/null || echo "Failed to monitor (PipeWire crash protection)"
          ;;
        2)
          echo "Monitoring Midi Through - should show data if M2 is connected:"
          # Use timeout to avoid hanging if no connection
          timeout 15s aseqdump -p 14:0 2>/dev/null || echo "No data received or timeout"
          ;;
        3)
          echo "Connection status:"
          if aconnect -l | grep -A5 "client 24" | grep -q "14:0"; then
            echo "✓ M2 is connected to Midi Through"
          else
            echo "✗ M2 is NOT connected to Midi Through"
            echo "Run: aconnect 24:0 14:0"
          fi
          ;;
        4)
          echo "Testing connection..."
          if aconnect 24:0 14:0 2>/dev/null; then
            echo "✓ Connected for test"
            echo "Play some MIDI notes now - monitoring for 10 seconds:"
            timeout 10s aseqdump -p 14:0 2>/dev/null || echo "No data or timeout"
            aconnect -d 24:0 14:0 2>/dev/null
            echo "Test connection removed"
          else
            echo "✗ Test connection failed"
          fi
          ;;
      esac
    '';
    executable = true;
  };

  # Install required packages
  home.packages = with pkgs; [
    alsa-utils
  ];
}
