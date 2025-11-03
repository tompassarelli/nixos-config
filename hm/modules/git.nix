{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.git;
in
{
  options.myConfig.git = {
    enable = lib.mkEnableOption "Git configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "tompassarelli";
      userEmail = "tom.passarelli@protonmail.com";
      delta = {
        enable = true;
        options = {
          navigate = true;
          color-only = true;
          #syntax-theme = "DarkNeon"; # handled by stylix?
        };
      };
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };
  };
}
