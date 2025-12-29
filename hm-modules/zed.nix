{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;

    # https://github.com/zed-industries/extensions/tree/main/extensions
    extensions = [
      "bearded-icon-theme"
      "codebook"
      "discord-presence"
      "git-firefly"
      "log"
      "nix"
      "nu"
      "nvim-nightfox"
      "rust-snippets"
      "svelte"
      "svelte-snippets"
      "toml"
      "html"
    ];

    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-tab" = "pane::ActivateNextItem";
          "ctrl-shift-tab" = "pane::ActivatePreviousItem";
        };
      }
      {
        context = "Workspace";
        bindings = {
          "ctrl-tab" = null;
          "ctrl-shift-tab" = null;
        };
      }
    ];

    userSettings = {
      theme = "Carbonfox - blurred";

      # AI
      agent = {
        dock = "left";

        default_model = {
          provider = "openrouter";
          model = "qwen/qwen3-coder:free";
        };

        profiles = {
          write = {
            name = "Write";
            tools.project_notifications = true;
          };

          ask = {
            name = "Ask";
            tools.project_notifications = true;
          };
        };
      };

      # UI
      toolbar = {
        breadcrumbs = false;
        quick_actions = false;
        code_actions = false;
      };

      title_bar.show_branch_icon = true;

      scrollbar.show = "never";

      minimap = {
        show = "always";
        display_in = "all_editors";
        thumb_border = "none";
        current_line_highlight = "line";
      };

      project_panel = {
        dock = "right";
        entry_spacing = "standard";
        indent_size = 15;
        scrollbar.show = "never";
        hide_root = true;
      };

      outline_panel.button = false;

      collaboration_panel = {
        dock = "right";
        default_width = 240;
      };

      git_panel = {
        dock = "right";
        status_style = "label_color";
        collapse_untracked_diff = true;
        scrollbar.show = "never";
      };

      tab_bar = {
        show_nav_history_buttons = false;
        show_tab_bar_buttons = false;
      };

      tabs = {
        show_close_button = "hidden";
        show_diagnostics = "errors";
      };

      preview_tabs = {
        enable_preview_from_file_finder = true;
        enable_preview_from_multibuffer = true;
        enable_preview_from_project_panel = true;
        enable_preview_file_from_code_navigation = true;
        enable_keep_preview_on_code_navigation = true;
      };

      # UI Font
      ui_font_family = "Arial";
      ui_font_fallbacks = [ ".ZedMono" ];
      # ui_font_size = 16;
      agent_buffer_font_size = 16;

      # Editor Font
      buffer_font_family = "FiraCode Nerd Font Mono";
      buffer_font_fallbacks = [ ".ZedMono" ];
      # buffer_font_size = 16;

      # LSP
      lsp = {
        nil.settings = {
          maxMemoryMB = 2048;
          nix.flake = {
            autoArchive = true;
            autoEvalInputs = true;
          };
        };
      };

      # Misc
      autosave.after_delay.milliseconds = 1500;

      icon_theme = "Bearded Icon Theme";

      features = {
        edit_prediction_provider = "supermaven";
      };

      edit_predictions = {
        mode = "subtle";
        enabled_in_text_threads = true;
      };

      diagnostics.inline.enabled = true;

      git.inline_blame.enabled = true;

      terminal = {
        blinking = "on";
        scrollbar.show = "never";

        keep_selection_on_copy = false;

        detect_venv.on = {
          directories = [
            ".env"
            "env"
            ".venv"
            "venv"
            ".direnv"
          ];
          activate_script = "nushell";
        };
      };

      pane_split_direction_horizontal = "up";
      pane_split_direction_vertical = "left";

      helix_mode = true;

      restore_on_startup = "none";

      use_system_path_prompts = false;

      show_edit_predictions = false;

      middle_click_paste = false;

      inlay_hints.enabled = false;

      extend_comment_on_newline = false;

      soft_wrap = "editor_width";

      profiles = { };
    };
  };

  home.packages = with pkgs; [
    nil
    nixd
  ];
}
