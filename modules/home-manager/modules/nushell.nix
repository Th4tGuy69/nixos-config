{ ... }:

{
  flake.homeModules.nushell =
    { config, lib, ... }:
    {
      persistence.files = [ ".config/nushell/history.txt" ];

      programs.nushell = with lib.hm.nushell; {
        enable = true;

        shellAliases = {
          rb = "rebuild";
        };

        settings = {
          show_banner = false;

          ls = {
            use_ls_colors = true;
            clickable_links = true;
          };

          rm.always_trash = false;

          table = {
            mode = "rounded";
            index_mode = "always";
            show_empty = true;
            padding = {
              left = 1;
              right = 1;
            };
            trim = {
              methodology = "wrapping";
              wrapping_try_keep_words = true;
              truncating_suffix = "...";
            };
            header_on_separator = false;
            footer_inheritance = false;
          };

          error_style = "fancy";

          display_errors = {
            exit_code = false;
            termination_signal = true;
          };

          history = {
            max_size = 100000;
            sync_on_enter = true;
            file_format = "plaintext";
            isolation = false;
          };

          completions = {
            case_sensitive = false;
            quick = true;
            partial = true;
            algorithm = "prefix";
            sort = "smart";
            external = {
              enable = true;
              max_results = 100;
            };
            use_ls_colors = true;
          };

          cursor_shape = {
            emacs = "line";
            vi_insert = "block";
            vi_normal = "underscore";
          };

          footer_mode = 25;
          float_precision = 2;
          use_ansi_coloring = true;
          bracketed_paste = true;
          edit_mode = "emacs";

          shell_integration = {
            osc2 = true;
            osc7 = true;
            osc8 = true;
            osc9_9 = false;
            osc133 = true;
            osc633 = true;
            reset_application_mode = true;
          };

          render_right_prompt_on_last_line = false;
          use_kitty_protocol = false;
          highlight_resolved_externals = false;
          recursion_limit = 50;

          plugin_gc = {
            default = {
              enabled = true;
              stop_after = mkNushellInline "10sec";
            };
            plugins = { };
          };

          color_config = mkNushellInline ''
            {
              binary: '#cc55cc'
              block: '#5555cc'
              cell-path: '#cccccc'
              closure: '#7acaca'
              custom: '#ffffff'
              duration: '#cdcd55'
              float: '#ff5555'
              glob: '#ffffff'
              int: '#cc55cc'
              list: '#7acaca'
              nothing: '#cc5555'
              range: '#cdcd55'
              record: '#7acaca'
              string: '#55cc55'
              bool: {|| if $in { '#55ffff' } else { '#cdcd55' } }
              foreground: '#b3b3b3'
              background: '#000000'
              cursor: '#b3b3b3'
              empty: '#5555cc'
              header: { fg: '#55cc55' attr: 'b' }
              hints: '#555555'
              leading_trailing_space_bg: { attr: 'n' }
              row_index: { fg: '#55cc55' attr: 'b' }
              search_result: { fg: '#cc5555' bg: '#cccccc' }
              separator: '#cccccc'
            }
          '';

        };

        extraConfig = ''
          def rebuild [] {
            cd /etc/nixos

            let hostname = (hostname | str trim)

            let target = match $hostname {
              "desktop" => "desktop"
              "fw13pro" => "laptop"
              _ => {
                print $"Unknown hostname: ($hostname)"
                input "Which flake should be built? "
              }
            }

            if ($target | is-empty) {
              error make { msg: "No flake target provided. Aborting rebuild." }
            }

            print $"Building flake: ($target)"

            git -c include.path=${config.home.homeDirectory}/.gitconfig add .

            sudo nixos-rebuild switch --flake $"/etc/nixos#($target)"

            git -c include.path=${config.home.homeDirectory}/.gitconfig commit -m (date now | format date '%D %r')

            print -n "\nPush to github? [y/N] (5s): "
            let key = try {
              input listen --types [key] --timeout 5sec
            } catch {
              null
            }
            print ""

            let push = if $key == null {
              false
            } else if $key.code == "y" or $key.code == "Y" {
              true
            } else {
              false
            }

            if $push {
              git -c include.path=${config.home.homeDirectory}/.gitconfig push
            }
          }
        '';
      };
    };
}
