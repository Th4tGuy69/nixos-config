{ pkgs, ... }:

{
  # https://nixos.wiki/wiki/Git
  programs.git = rec {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    lfs.enable = true;

    userName = "that-guy.dev";
    userEmail = "admin@that-guy.dev";

    extraConfig = {
      credential.helper = "${package}/bin/git-credential-libsecret";
    };
  };
}
