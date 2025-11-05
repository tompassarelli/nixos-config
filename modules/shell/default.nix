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
          # shorthands
          gits = "git status";
          gitsc = "git status --cached";
          gitd = "git diff";
          gita = "git add .";
          rebuild = "sudo nixos-rebuild switch --flake ~/code/nixos-config/";
        };
        interactiveShellInit = ''
          # Initialize zoxide
          zoxide init fish | source

          # Initialize atuin
          atuin init fish | source

          # Git commit with message (no quotes needed)
          function gitm
            git commit -m "$argv"
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
