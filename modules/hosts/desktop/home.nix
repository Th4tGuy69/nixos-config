{ self, ... }:

{
  flake.homeModules.thatguyHome =
    { pkgs, ... }:
    {
      imports = [
        # ./sops.nix
        ./_modules/hyprland.nix
        ./_modules/pipewire.nix
        # ./_modules/gtk.nix
        # ./_modules/nixcord.nix
        ./_modules/fonts.nix
        ./_modules/ghostty.nix
        ./_modules/xdg.nix
        ./_modules/git.nix
        ./_modules/wine.nix
        ./_modules/syncthing.nix
        ./_modules/gpg.nix
        # ./_modules/mako.nix
        ./_modules/nushell.nix
        ./_modules/starship.nix
        ./_modules/vscode.nix
        ./_modules/celluloid.nix
        ./_modules/qemu.nix
        ./_modules/env.nix
        ./_modules/aliases.nix
        ./_modules/zoxide.nix
        ./_modules/yazi.nix
        ./_modules/helix.nix
        ./_modules/ssh.nix
        ./_modules/direnv.nix
        # ./_modules/cursor.nix
        ./_modules/stylix.nix
        # ./_modules/quickshell.nix
        # ./_modules/music.nix
        ./_modules/zed.nix
        ./_modules/btop.nix
        ./_modules/mpv.nix
        ./_modules/zen-browser.nix
        # ./_modules/seanime.nix
        ./_modules/pay-respects.nix
        # ./_modules/niri.nix
        ./_modules/linux-wallpaperengine.nix
        ./_modules/scroll.nix
        ./_modules/rbw.nix
      ];

      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      home.username = "thatguy";
      home.homeDirectory = "/home/thatguy";
      # home.usernamebackupFileExtension = "hm-backup";

      # The home.packages option allows you to install Nix packages into your
      # environment.
      home.packages = with pkgs; [
        # inputs.helium.packages.${system}.default

        self.packages.${pkgs.system}.seanime-denshi

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
      ];

      # nixpkgs = {
      #   config.allowUnfree = true;
      #   overlays = [
      #     inputs.nur.overlays.default
      #     # inputs.niri.overlays.niri
      #     # Add support for nautilus trash and networking
      #     (self: super: {
      #       gnome = super.gnome.overrideScope (
      #         gself: gsuper: {
      #           nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
      #             buildInputs =
      #               nsuper.buildInputs
      #               ++ (with pkgs.gst_all_1; [
      #                 gst-plugins-good
      #                 gst-plugins-bad
      #               ]);
      #           });
      #         }
      #       );
      #     })
      #   ];
      # };

      programs.home-manager.enable = true;

      home.stateVersion = "26.05"; # Don't change me
    };
}
