{ config, lib, pkgs, username, ... }:

let
  cfg = config.myConfig.utilities;
in
{
  options.myConfig.utilities = {
    enable = lib.mkEnableOption "system utilities and modern CLI tools";
  };

  config = lib.mkIf cfg.enable {
    # ============ SYSTEM-LEVEL CONFIGURATION ============

    environment.systemPackages = with pkgs; [
    # Icons & Themes
    #papirus-icon-theme   # nice icon set
    adwaita-icon-theme   # default GNOME icons (needed for nautilus)
    gnome-themes-extra   # includes Adwaita-dark theme

    # System Input
    wl-clipboard         # clipboard utilities
    brightnessctl        # control brightness

    # System Monitor
    fastfetch            # print your system config in the terminal
    btop                 # power, cpu, etc usage

    # Legacy app support
    xwayland-satellite   # (required as of 2025 for a few apps, like bitwarden)

    # User utilities
    tree                 # display a file tree
    dust                 # disk usage analyzer
    eza                  # modern ls replacement
    procs                # modern ps replacement
    tealdeer             # tldr for quick command examples
    pomodoro-gtk         # pomodoro
    ];

    # ============ HOME-MANAGER CONFIGURATION ============

    home-manager.users.${username} = { config, ... }: {
      # Tealdeer (tldr) configuration
      xdg.configFile."tealdeer/config.toml".source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/code/nixos-config/modules/utilities/dotfiles/config.toml";
    };
  };
}
