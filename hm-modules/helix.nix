{ ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "carbonfox";

      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };

      keys.normal = {
        "C-_" = "toggle_comments";
      };
    };

    languages.language = [
      {
        name = "nix";
        auto-format = true;
      }
    ];
  };
}
