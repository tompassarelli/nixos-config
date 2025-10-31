{ config, pkgs, ... }:

{
  # Git configuration
  # Requires home-manager for programs.git
  
  programs.git = {
    enable = true;
    userName = "tompassarelli";
    userEmail = "tom.passarelli@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      delta.syntax-theme = "Catppuccin-mocha";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };
}
