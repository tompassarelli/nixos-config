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
          # shorthands
          gs = "git status";
          gd = "git diff";
        };
        functions = {
          fish_prompt = {
            body = ''
              set -l pwd (pwd)
              echo -n (set_color brblue)"$pwd"(set_color normal)" > "
            '';
          };
        };
        interactiveShellInit = ''
          # Bind Ctrl+L to accept autosuggestion
          bind \cl accept-autosuggestion

          # Initialize zoxide
          zoxide init fish | source

          # Initialize atuin
          atuin init fish | source
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
    };
  };
}
