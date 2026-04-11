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
        "C-/" = "toggle_comments";
        "C-left" = "move_prev_word_start";
        "C-right" = "move_next_word_end";
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
