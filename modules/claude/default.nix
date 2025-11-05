{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.claude;
in
{
  options.myConfig.claude = {
    enable = lib.mkEnableOption "Claude Code CLI configuration";
  };

  config = lib.mkIf cfg.enable {
    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = { config, ... }: {
      # Claude settings.json
      home.file.".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/claude/settings.json";

      # Claude custom commands directory (global commands)
      home.file.".claude/commands".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/dotfiles/claude/commands";
    };
  };
}
