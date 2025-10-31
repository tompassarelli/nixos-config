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
    interactiveShellInit = ''
      # Bind Ctrl+L to accept autosuggestion
      bind \cl accept-autosuggestion
    '';
  };

  # GTK theming handled by Stylix
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # dotfiles (all with instant updates without rebuild)
  xdg.configFile."rofi/config.rasi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/config.rasi";
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/niri/config.kdl";
  xdg.configFile."waybar/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/waybar/config";
  # waybar/style.css removed - let Stylix generate themed CSS
  xdg.configFile."waybar/overview-waybar.py".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/waybar/overview-waybar.py";
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/nvim";

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
      icons = 0; # Hide app icons
      
      # Claude Code notifications auto-dismiss after 2 seconds
      "app-name=kitty" = {
        default-timeout = 2000;
      };
    };
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
