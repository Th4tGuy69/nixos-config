{ config, pkgs, inputs, ... }:

let
  # Locally defined packages
  helium = import ./packages/helium.nix { pkgs = pkgs; };
in

{
  # Module imports
  imports = [
    ./secrets/sops-hm.nix
    
    ./hm-modules/hyprland.nix
    ./hm-modules/pipewire.nix
    #./hm-modules/gtk.nix
    #./hm-modules/nixcord.nix
    ./hm-modules/fonts.nix
    ./hm-modules/ghostty.nix
    ./hm-modules/xdg.nix
    ./hm-modules/git.nix
    ./hm-modules/wine.nix
    ./hm-modules/syncthing.nix
    ./hm-modules/gpg.nix
    #./hm-modules/mako.nix
    ./hm-modules/nushell.nix
    ./hm-modules/starship.nix
    ./hm-modules/vscode.nix
    ./hm-modules/celluloid.nix
    ./hm-modules/bevy.nix
    ./hm-modules/qemu.nix
    ./hm-modules/env.nix
    ./hm-modules/aliases.nix
    ./hm-modules/zoxide.nix
    ./hm-modules/yazi.nix
    ./hm-modules/helix.nix
    ./hm-modules/ssh.nix
    ./hm-modules/direnv.nix
    # ./hm-modules/cursor.nix
    ./hm-modules/stylix.nix
    # ./hm-modules/quickshell.nix
    ./hm-modules/music.nix
    ./hm-modules/zed.nix
    ./hm-modules/btop.nix
    ./hm-modules/mpv.nix
    ./hm-modules/zen-browser.nix
    ./hm-modules/seanime.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thatguy";
  home.homeDirectory = "/home/thatguy";

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
    "qtwebengine-5.15.19" # For Stremio
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [ 
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
    stremio
    playerctl
    via
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
      withEquicord = false;
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
    #gitbutler
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
    wlx-overlay-s
    bottles
    # networkmanagerapplet
    helvum
    devenv
    # pakku
    gdu
    # bottom
    lumafly
    helium
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
