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
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      ps = "procs";
      gs = "git status";
      vi = "nvim";
      cd = "z";  # use zoxide for cd
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

  # walker config
  xdg.configFile."walker/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/walker/config.toml";

  # tealdeer config
  xdg.configFile."tealdeer/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/tealdeer/config.toml";

  # version control
  programs.git = {
    enable = true;
    userName = "tompassarelli";
    userEmail = "tom.passarelli@protonmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
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

  # swaybg wallpaper service
  systemd.user.services.swaybg = {
    Unit = {
      Description = "Wayland wallpaper tool";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -m fill -i %h/code/nixos-config/wallpaper.jpg";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # waybar status bar service
  systemd.user.services.waybar = {
    Unit = {
      Description = "Highly customizable Wayland bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # waybar overview script service
  systemd.user.services.waybar-overview = {
    Unit = {
      Description = "Waybar overview listener script";
      PartOf = [ "graphical-session.target" ];
      After = [ "waybar.service" ];
      Requires = [ "waybar.service" ];
    };
    Service = {
      ExecStart = "%h/.config/waybar/overview-waybar.py";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # swayidle idle management service
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Idle manager for Wayland";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 601 'niri msg action power-off-monitors' timeout 600 'swaylock -f' before-sleep 'swaylock -f'";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  # walker service (runs in background for fast launch)
  systemd.user.services.walker = {
    Unit = {
      Description = "Walker application launcher service";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      Requisite = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
      Restart = "on-failure";
      Type = "dbus";
      BusName = "me.halfmexican.walker";
    };
    Install = {
      WantedBy = [ "niri.service" ];
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

    # Media viewers
    imv              # image viewer
    mpv              # video player
    zathura          # PDF viewer

    # User utilities
    tree
    dust             # disk usage analyzer (better than ncdu for overview)
    walker           # modern wayland app launcher
    eza              # modern ls replacement
    procs            # modern ps replacement
    tealdeer         # tldr for quick command examples
    delta            # beautiful git diffs
  ];
}
