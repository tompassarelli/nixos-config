{ config, pkgs, ... }:

{
  # Dotfiles management
  # Requires home-manager for xdg.configFile

  # Rofi
  xdg.configFile."rofi/config.rasi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/config.rasi";
   
  # Niri
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/niri/config.kdl";

  # Waybar
  xdg.configFile."waybar/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/waybar/config";
  # waybar/style.css removed - let Stylix generate themed CSS
  xdg.configFile."waybar/overview-waybar.py".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/waybar/overview-waybar.py";

  # Neovim
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/nvim";

  # Walker
  xdg.configFile."walker/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/walker/config.toml";

  # Tealdear (tldr)
  xdg.configFile."tealdeer/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/tealdeer/config.toml";
}
