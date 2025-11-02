{ config, lib, pkgs, ... }:

{
  # System utilities and modern CLI tools
  environment.systemPackages = with pkgs; [
    # Night light
    wl-gammarelay-rs     # live gamma control for wayland

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
    tree
    dust                 # disk usage analyzer
    walker               # modern wayland app launcher
    eza                  # modern ls replacement
    procs                # modern ps replacement
    tealdeer             # tldr for quick command examples
  ];
}