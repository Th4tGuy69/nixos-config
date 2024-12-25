{ config, pkgs, inputs, ... }:

let
  # Locally defined packages
  future-cursors = import ./packages/future-cursors.nix { 
    lib = pkgs.lib; 
    stdenvNoCC = pkgs.stdenvNoCC;
    fetchFromGitHub = pkgs.fetchFromGitHub; 
  };
in

{
  # Module imports
  imports = [
    inputs.nixcord.homeManagerModules.nixcord

    ./modules/hyprland.nix
    ./modules/tofi.nix
    ./modules/hrtf-EQ.nix
    ./modules/gtk.nix
    ./modules/nixcord.nix
    ./modules/fonts.nix
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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    #pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    kitty
    inputs.zen-browser.packages.x86_64-linux.specific
    spotify
    pavucontrol
    tofi
    lutris
    mangohud
    gamemode
    gamescope
    protonplus # Doesn't work?
    protonup-qt
    hyprsunset
    nautilus
    awf
    git
    warp-terminal
    lapce
    fontpreview
    gh
  ];

  # possible fix for home.sessionVariables
  programs.kitty.enable = true;

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