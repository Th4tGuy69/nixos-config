{ ... }:

{
  # https://nixos.wiki/wiki/Git
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "That Guy";
    userEmail = "ThatGuyTF3@outlook.com";
  };
}
