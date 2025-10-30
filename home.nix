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

  # GTK dark theme for nautilus and other GTK apps
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # rofi launcher - just use the working config file
  xdg.configFile."rofi/config.rasi".source = ./dotfiles/config.rasi;

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

  # waybar config
  xdg.configFile."waybar/config".source = ./dotfiles/waybar/config;
  xdg.configFile."waybar/style.css".source = ./dotfiles/waybar/style.css;
  xdg.configFile."waybar/overview-waybar.py" = {
    source = ./dotfiles/waybar/overview-waybar.py;
    executable = true;
  };

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
