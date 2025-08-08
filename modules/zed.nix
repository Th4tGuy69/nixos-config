{ pkgs, ... }:

{  
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;

    # https://github.com/zed-industries/extensions/tree/main/extensions
    extensions = [
      "html"
      "nix"
      "bearded-icon-theme"
      "toml"
      "nu"
      "git-firefly"
    ];
  };

  home.packages = with pkgs; [
    nil
    nixd
  ];
}
