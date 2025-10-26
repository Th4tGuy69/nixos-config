{ pkgs, ... }:

{
  # https://nixos.wiki/wiki/Git
  programs.git = rec {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    lfs.enable = true;

    settings = {
      user.name = "that-guy.dev";
      user.email = "admin@that-guy.dev";

      credential.helper = "${package}/bin/git-credential-libsecret";
    };
  };
}
