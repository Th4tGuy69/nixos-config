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
    ./modules/hrtf-EQ.nix
    ./modules/gtk.nix
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
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thatguy";
  home.homeDirectory = "/home/thatguy";

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    inputs.zen-browser.packages.x86_64-linux.zen-browser
    spotify
    pavucontrol
    lutris
    mangohud
    gamemode
    gamescope
    protonplus # Doesn't work?
    protonup-qt
    nautilus
    nautilus-open-any-terminal
    awf
    lapce
    fontpreview
    gh
    zoxide
    microfetch
    fd
    kitty
    prismlauncher
    steam
    goverlay
    kodi-wayland
    stremio
    playerctl
    via
    grimblast
    #(discord.override {
    #  withOpenASAR = true;
    #  withVencord = true;
    #  #withEquicord = true;
    #})
    equibop
    p7zip
    thunderbird-latest
    obsidian
    bitwarden-desktop
    keyguard
    #goldwarden
    libnotify
    unityhub
    turtle
    sushi
    socat
    baobab
    libgit2
    #gitbutler
    #gitbutler-local
    github-desktop
    jetbrains.rider
    qalculate-gtk
    seanime-local
    mpv
    zoom-us
    feishin
    gnome-system-monitor
    android-studio
    android-tools
    flutter
    gimp
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

  # Home Manager managed environment variables 
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Hint Electron apps to use Wayland
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
