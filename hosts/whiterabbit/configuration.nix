# Host-specific config for whiterabbit (Framework 13 laptop)
# This matches exactly what was in flake.nix before refactor
{ lib, ... }:
{
  # Hardware
  myConfig.framework.enable = true;
  myConfig.via.enable = false;
  myConfig.audio.enable = true;
  myConfig.bluetooth.enable = true;
  myConfig.printing.enable = true;

  myConfig.input.enable = true;
  myConfig.kanata = {
    enable = true;
    capsLockEscCtrl = true;
    leftAltAsSuper = true;
    wideMod = true;
  };

  # System
  myConfig.system.stateVersion = "25.05";
  myConfig.nix-settings.enable = true;
  myConfig.boot.enable = true;
  myConfig.users.enable = true;
  myConfig.users.username = "tom";
  myConfig.networking.enable = true;
  myConfig.timezone.enable = true;
  myConfig.ssh.enable = true;
  myConfig.auto-upgrade.enable = true;

  # Terminal
  myConfig.terminal.enable = true;
  myConfig.shell.enable = true;

  # Utils
  myConfig.yazi.enable = true;
  myConfig.tree.enable = true;
  myConfig.dust.enable = true;
  myConfig.eza.enable = true;
  myConfig.procs.enable = true;
  myConfig.tealdeer.enable = true;
  myConfig.fastfetch.enable = true;
  myConfig.btop.enable = true;

  # Desktop Environment
  myConfig.niri.enable = true;
  myConfig.power.enable = true;
  myConfig.security.enable = true;
  myConfig.rofi-wayland.enable = false;
  myConfig.walker.enable = true;
  myConfig.waybar.enable = true;
  myConfig.mako.enable = true;

  # Theming
  myConfig.gtk.enable = true;
  myConfig.styling.enable = true;
  myConfig.theming.enable = true;
  myConfig.theming.chosenTheme = "tokyo-night-dark";
  myConfig.theme-switcher.enable = true;

  # Development
  myConfig.git.enable = true;
  myConfig.neovim.enable = true;
  myConfig.doom-emacs.enable = true;
  myConfig.development.enable = true;
  myConfig.zed.enable = true;
  myConfig.rust = {
    enable = true;
    bevy = true;
  };
  myConfig.claude.enable = true;
  myConfig.postgresql.enable = true;
  myConfig.direnv.enable = true;

  # Applications
  myConfig.web-browser = {
    enable = true;
    fennec.enable = true;
    chrome.enable = true;
  };
  myConfig.steam.enable = true;
  myConfig.productivity.enable = true;
  myConfig.creative.enable = true;
  myConfig.media.enable = true;
  myConfig.password.enable = true;
  myConfig.mail.enable = true;
}
