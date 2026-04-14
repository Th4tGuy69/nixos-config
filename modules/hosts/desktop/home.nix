{ self, ... }:

{
  flake.homeModules.thatguyHome =
    { pkgs, ... }:
    {
      imports = with self.homeModules; [
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
        hyprland
        linux-wallpaperengine
        mpv
        nushell
        # pay-respects
        pipewire
        qemu
        rbw
        scroll
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

      home = {
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
            lutris
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
            (prismlauncher.override {
              jdks = [
                graalvmPackages.graalvm-ce
                zulu8
                zulu17
                zulu
              ];
            })
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
            bottles
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

        username = "thatguy";
        homeDirectory = "/home/thatguy";

        stateVersion = "26.05"; # Don't change me
      };

      programs.home-manager.enable = true;

    };
}
