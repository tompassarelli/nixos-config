{ config, lib, pkgs, ... }:

{
  # Neovim text editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}