{ self, ... }:

{
  flake.homeModules.thatguyHome =
    { pkgs, ... }:
    {
      imports = with self.homeModules; [
        gui
        aliases
        btop
        celluloid
        direnv
        env
        fonts
        ghostty
        git
        gpg
        helix
        # hyprland
        # niri # Uncomment to use niri
        scroll # Uncomment to use scroll
        # hyprpanel  # Uncomment if gui.bar = "hyprpanel"
        # eww        # Uncomment if gui.bar = "eww"
        # quickshell # Uncomment if gui.bar = "quickshell"
        anyrun # Uncomment if gui.runner = "anyrun"
        # sherlock  # Uncomment if gui.runner = "sherlock"
        linux-wallpaperengine
        mpv
        nushell
        pay-respects
        pipewire
        prismlauncher
        qemu
        rbw
        sops
        ssh
        starship
        stylix
        syncthing
        vscode
        wine
        xdg
        yazi
        zed
        zen-browser
        zoxide

        # cursor
        # gtk
        # mako
        # music
        # niri
        # nixcord
        # quickshell
      ];

      gui = {
        windowManager = "hyprland";
        bar = null;
        runner = "anyrun";
        terminal = "ghostty";
        fileManager = "nautilus";
        monitors = [
          {
            name = "DP-1";
            preferred = true;
            x = 0;
            y = 0;
            scale = 1;
          }
          {
            description = "LG Electronics 27GL650F 008NTHM5V961";
            preferred = true;
            x = -1080;
            y = -56;
            scale = 1;
            transform = 90;
          }
          {
            description = "Hisense Electric Co. Ltd. HISENSE 0x00000001";
            width = 3840;
            height = 2160;
            refreshRate = 60;
            x = 0;
            y = 0;
            scale = 2;
          }
        ];
        startupApps = [
          "zen-beta"
          "discord"
          "spotify"
          "steam -silent"
        ];
      };

      git.name = "that-guy.dev";
      git.email = "admin@that-guy.dev";

      home = {
        username = "thatguy";
        homeDirectory = "/home/thatguy";

        packages =
          (with self.packages.${pkgs.system}; [
            # my packages
            seanime-denshi
            nerdshade
          ])
          ++ (with pkgs; [
            # nixpkgs

            spotify
            pavucontrol
            # lutris
            mangohud
            gamemode
            gamescope
            # protonplus
            # protonup-qt
            nautilus
            nautilus-open-any-terminal
            # awf
            #lapce
            fontpreview
            gh
            fd
            kitty
            #steam
            goverlay
            #kodi-wayland
            # stremio
            playerctl
            via
            vial
            (discord.override {
              withOpenASAR = true;
              withVencord = false;
              withEquicord = true;
              withMoonlight = false;
              withTTS = false;
              enableAutoscroll = true;
            })
            #equibop
            #goofcord
            p7zip
            # thunderbird-latest
            obsidian
            bitwarden-desktop
            #keyguard
            libnotify
            #unityhub
            turtle
            sushi
            kdePackages.filelight
            gitbutler
            #github-desktop
            #jetbrains.rider
            #jetbrains.clion
            qalculate-gtk
            #zoom-us
            # feishin
            gnome-system-monitor
            #android-studio
            #android-tools
            #flutter
            gimp
            r2modman
            obs-studio
            blender
            #gcc
            wayvr
            # bottles
            # networkmanagerapplet
            # helvum
            crosspipe
            devenv
            # pakku
            gdu
            # bottom
            lumafly
            element-desktop
            deadlock-mod-manager
          ]);

        stateVersion = "26.05"; # Don't change me
      };

      programs.home-manager.enable = true;
    };
}
