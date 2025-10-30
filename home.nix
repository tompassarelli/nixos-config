{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
  
  # terminal
  programs.kitty = {
    enable = true;
    settings = {
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
    };
  };

  # shell
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      gs = "git status";
      vi = "nvim";
    };
    functions = {
      fish_prompt = {
        body = ''
          set -l pwd (pwd)
          echo -n (set_color brblue)"$pwd"(set_color normal)" > "
        '';
      };
    };
  };

  # version control
  programs.git = {
    enable = true;
    userName = "tompassarelli";
    userEmail = "tom.passarelli@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # file manager (tui)
  programs.yazi = {
    enable = true;
    settings = {
      opener = {
        edit = [
          { run = "nvim \"$@\""; block = true; for = "unix"; }
        ];
      };
    };
  };

  # notifications
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 0; # Don't auto-dismiss notifications
    };
  };

  # niri window manager config
  xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/config.kdl;

  home.packages = with pkgs; [
    # Personal productivity
    obsidian
    todoist-electron
    protonmail-desktop
    bitwarden

    # Creative tools
    godot_4
    blender
    gimp

    # Social/Communication
    discord
    zoom-us

    # Music
    spotify
    youtube-music

    # User utilities
    tree
  ];
}
