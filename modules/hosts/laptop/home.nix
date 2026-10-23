{ self, ... }:

{
  flake.homeModules.laptopHome =
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
        niri # Uncomment to use niri
        helium
        scroll # Uncomment to use scroll
        # hyprpanel  # Uncomment if gui.bar = "hyprpanel"
        # eww        # Uncomment if gui.bar = "eww"
        # quickshell # Uncomment if gui.bar = "quickshell"
        anyrun # Uncomment if gui.runner = "anyrun"
        # sherlock  # Uncomment if gui.runner = "sherlock"
        # linux-wallpaperengine
        mpv
        nushell
        pay-respects
        persistence
        pipewire
        # prismlauncher
        qemu
        rbw
        sops
        ssh
        starship
        stylix
        syncthing
        # vscode
        wlsunset
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
        ];
        startupApps = [
          "zen-beta"
        ];
      };

      persistence = {
        directories = [
          ".local/share/direnv"
          "Downloads"
          {
            directory = ".gnupg";
            mode = "0700";
          }
          {
            directory = ".local/share/keyrings";
            mode = "0700";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
        ];
        files = [

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
            # seanime-denshi
            nerdshade
            keyguard
          ])
          ++ (with pkgs; [
            # nixpkgs

            spotify
            pavucontrol
            # lutris
            # mangohud
            # gamemode
            # gamescope
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
            # playerctl
            # via
            # vial
            # (discord.override {
            #   withOpenASAR = true;
            #   withVencord = false;
            #   withEquicord = true;
            #   withMoonlight = false;
            #   withTTS = false;
            #   enableAutoscroll = true;
            # })
            #equibop
            #goofcord
            p7zip
            # thunderbird-latest
            obsidian
            # bitwarden-desktop
            # keyguard # is the mobile version for some reason
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
            # r2modman
            obs-studio
            blender
            #gcc
            # wayvr
            # bottles
            # networkmanagerapplet
            # helvum
            crosspipe
            devenv
            # pakku
            gdu
            # bottom
            # lumafly
            element-desktop
            # deadlock-mod-manager
          ]);

        stateVersion = "26.05"; # Don't change me
      };

      programs.home-manager.enable = true;
    };
}
