{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.shell;
in
{
  options.myConfig.shell = {
    enable = lib.mkEnableOption "Shell environment configuration";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

    # Enable fish shell system-wide
    programs.fish.enable = true;

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = {
      # Fish shell configuration
      programs.fish = {
        enable = true;
        shellAliases = {
          # modern utils
          cd = "z";  # use zoxide for cd
          du = "dust";
          ls = "eza";
          ps = "procs";
          vim = "nvim"; # keep vi as fallback
          v = "nvim";
          # emacs client (connect to daemon for fast startup)
          e = "emacsclient -c -a emacs";  # -c = new frame, -a emacs = fallback to emacs if daemon not running
          # shorthands
          gits = "git status";
          gitd = "git diff";
          gitdc = "git diff --cached";
          gita = "git add -v . && git status";
          gitp = "git push";
          rebuild = "sudo nixos-rebuild switch --flake ~/code/nixos-config/";
        };
        interactiveShellInit = ''
          # Initialize zoxide
          zoxide init fish | source

          # Initialize atuin
          atuin init fish | source

          # Git commit with neovim in insert mode
          function gitc
            GIT_EDITOR="nvim -c 'startinsert'" git commit
          end

          # Copy file contents to clipboard
          function wlc
            if test -f "$argv[1]"
              cat "$argv[1]" | wl-copy
              echo "Copied $argv[1] to clipboard"
            else
              echo "Error: File not found: $argv[1]"
              return 1
            end
          end

          # Move most recent screenshot to current directory
          function movess
            set -l files ~/Pictures/Screenshots/*.png
            if test (count $files) -eq 0
              echo "No screenshots found"
              return 1
            end
            set -l newest $files[1]
            for file in $files
              test $file -nt $newest; and set newest $file
            end
            set -l ext (string match -r '\.[^.]+$' $newest)
            set -l name (basename $newest)
            mv $newest ./screenshot$ext
            echo "Moved: $name → ./screenshot$ext"
          end

          # Record screen demo with area selection
          function makedemo
            wf-recorder -g (slurp) -f demo.mp4
          end

          # Convert demo.mp4 to demo.gif
          function makegif
            if not test -f demo.mp4
              echo "Error: demo.mp4 not found"
              return 1
            end
            ffmpeg -i demo.mp4 -vf "fps=15,scale=800:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" demo.gif
            echo "Created: demo.gif"
          end
        '';
      };

      # zoxide smart directory jumper
      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      # atuin shell history
      programs.atuin = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          search_mode = "fuzzy";
        };
      };

      # starship prompt - minimal, git-focused
      programs.starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          add_newline = false;

          format = lib.concatStrings [
            "$directory"
            # "$git_branch"
            # "$git_status"
            "$character"
          ];

          directory = {
            truncation_length = 0;
            truncate_to_repo = false;
          };

          username.disabled = true;
          hostname.disabled = true;
        };
      };
    };
  };
}
