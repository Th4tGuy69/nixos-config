{ config, pkgs, inputs, ... }:

let
  # Locally defined packages
  seanime-local = import ./packages/seanime.nix { pkgs = pkgs; };
  seanime-desktop-local = import ./packages/seanime-desktop.nix { pkgs = pkgs; };
in

{
  # Module imports
  imports = [
    ./modules/hyprland.nix
    ./modules/pipewire.nix
    #./modules/gtk.nix
    #./modules/nixcord.nix
    ./modules/fonts.nix
    ./modules/sops.nix
    ./modules/ghostty.nix
    ./modules/xdg.nix
    ./modules/git.nix
    ./modules/wine.nix
    ./modules/syncthing.nix
    ./modules/gpg.nix
    #./modules/mako.nix
    ./modules/nushell.nix
    ./modules/starship.nix
    ./modules/vscode.nix
    ./modules/celluloid.nix
    ./modules/bevy.nix
    ./modules/qemu.nix
    ./modules/env.nix
    ./modules/aliases.nix
    ./modules/zoxide.nix
    ./modules/yazi.nix
    ./modules/helix.nix
    ./modules/ssh.nix
    ./modules/direnv.nix
    # ./modules/cursor.nix
    ./modules/stylix.nix
    ./modules/quickshell.nix
    ./modules/music.nix
    ./modules/zed.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thatguy";
  home.homeDirectory = "/home/thatguy";

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${system}.zen-browser
    
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
    microfetch
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
    (discord.override {
      withOpenASAR = true;
      vencord = pkgs.equicord;
      withVencord = false;
      withMoonlight = true;
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
    #gitbutler
    #github-desktop
    #jetbrains.rider
    #jetbrains.clion
    qalculate-gtk
    seanime-local
    # seanime-desktop-local
    mpv
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
    wlx-overlay-s
    bottles
    # networkmanagerapplet
    helvum
    devenv
    # pakku
  ];

  nixpkgs.overlays = [
    # Add support for nautilus trash and networking
    (self: super: {
      gnome = super.gnome.overrideScope' (gself: gsuper: {
        nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
          buildInputs = nsuper.buildInputs ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
        });
      });
    })
    (import ./overlays/equicord.nix)
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
