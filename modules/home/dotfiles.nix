{ config, pkgs, ... }:

{
  # Dotfiles management
  # Requires home-manager for xdg.configFile
  
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
}