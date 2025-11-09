{ config, lib, pkgs, username, inputs, ... }:

let
  cfg = config.myConfig.doom-emacs;
in
{
  options.myConfig.doom-emacs = {
    enable = lib.mkEnableOption "Doom Emacs via nix-doom-emacs-unstraightened";
  };

  config = lib.mkIf cfg.enable {
    # Import the nix-doom-emacs-unstraightened home-manager module
    home-manager.sharedModules = [
      inputs.nix-doom-emacs-unstraightened.homeModule
    ];

    # Configure doom-emacs via home-manager
    home-manager.users.${username} = { config, ... }: {
      programs.doom-emacs = {
        enable = true;
        doomDir = ../../dotfiles/doom;
        # Optional: add tree-sitter grammars
        extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
      };

      # Enable git, ripgrep, fd for Doom (if not already enabled)
      programs.git.enable = true;
      programs.ripgrep.enable = true;
      programs.fd.enable = true;
    };
  };
}
