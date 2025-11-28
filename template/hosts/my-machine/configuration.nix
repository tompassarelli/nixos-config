# My machine configuration
# Enable the modules you want from Firn
{ lib, ... }:
{
  # ============ REQUIRED ============
  myConfig.users.username = "yourname";  # Change this!

  # ============ SYSTEM ============
  myConfig.nix-settings.enable = true;
  myConfig.boot.enable = true;
  myConfig.users.enable = true;
  myConfig.networking.enable = true;
  myConfig.timezone.enable = true;
  myConfig.ssh.enable = true;
  # myConfig.auto-upgrade.enable = true;

  # ============ HARDWARE ============
  myConfig.audio.enable = true;
  myConfig.bluetooth.enable = true;
  myConfig.input.enable = true;
  # myConfig.framework.enable = true;  # Only for Framework laptops

  myConfig.kanata = {
    enable = true;
    capsLockEscCtrl = true;
    # leftAltAsSuper = true;
    # wideMod = true;
  };

  # ============ DESKTOP ============
  myConfig.niri.enable = true;
  myConfig.power.enable = true;
  myConfig.security.enable = true;
  myConfig.walker.enable = true;
  myConfig.waybar.enable = true;
  myConfig.mako.enable = true;

  # ============ THEMING ============
  myConfig.gtk.enable = true;
  myConfig.styling.enable = true;
  myConfig.theming.enable = true;
  myConfig.theming.chosenTheme = "tokyo-night-dark";
  # myConfig.theme-switcher.enable = true;

  # ============ TERMINAL & SHELL ============
  myConfig.terminal.enable = true;
  myConfig.shell.enable = true;

  # ============ CLI TOOLS ============
  myConfig.yazi.enable = true;
  myConfig.git.enable = true;
  myConfig.tree.enable = true;
  myConfig.dust.enable = true;
  myConfig.eza.enable = true;
  myConfig.procs.enable = true;
  myConfig.tealdeer.enable = true;
  myConfig.fastfetch.enable = true;
  myConfig.btop.enable = true;

  # ============ EDITORS ============
  myConfig.neovim.enable = true;
  # myConfig.doom-emacs.enable = true;

  # ============ DEVELOPMENT ============
  myConfig.development.enable = true;
  # myConfig.rust.enable = true;
  # myConfig.claude.enable = true;

  # ============ APPLICATIONS ============
  myConfig.web-browser = {
    enable = true;
    fennec.enable = true;
    # chrome.enable = true;
  };
  myConfig.productivity.enable = true;
  myConfig.media.enable = true;
  myConfig.password.enable = true;
  # myConfig.mail.enable = true;
  # myConfig.steam.enable = true;
  # myConfig.creative.enable = true;
}
