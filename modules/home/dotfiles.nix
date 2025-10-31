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
  
  # Generate stylix.css using exact Stylix logic
  xdg.configFile."waybar/stylix.css".text = with config.lib.stylix.colors; ''
    @define-color base00 #${base00};
    @define-color base01 #${base01};
    @define-color base02 #${base02};
    @define-color base03 #${base03};
    @define-color base04 #${base04};
    @define-color base05 #${base05};
    @define-color base06 #${base06};
    @define-color base07 #${base07};
    @define-color base08 #${base08};
    @define-color base09 #${base09};
    @define-color base0A #${base0A};
    @define-color base0B #${base0B};
    @define-color base0C #${base0C};
    @define-color base0D #${base0D};
    @define-color base0E #${base0E};
    @define-color base0F #${base0F};

    * {
      font-family: "${config.stylix.fonts.sansSerif.name}";
      font-size: ${toString config.stylix.fonts.sizes.desktop}pt;
    }

    window#waybar, tooltip {
      background: alpha(@base00, ${toString config.stylix.opacity.desktop});
      color: @base05;
    }

    tooltip {
      border-color: @base0D;
    }

    .modules-left #workspaces button {
      border-bottom: 3px solid transparent;
    }
    .modules-left #workspaces button.focused,
    .modules-left #workspaces button.active {
      border-bottom: 3px solid @base05;
    }

    .modules-center #workspaces button {
      border-bottom: 3px solid transparent;
    }
    .modules-center #workspaces button.focused,
    .modules-center #workspaces button.active {
      border-bottom: 3px solid @base05;
    }

    .modules-right #workspaces button {
      border-bottom: 3px solid transparent;
    }
    .modules-right #workspaces button.focused,
    .modules-right #workspaces button.active {
      border-bottom: 3px solid @base05;
    }
  '';
  
  xdg.configFile."waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/waybar/style.css";
  xdg.configFile."waybar/overview-waybar.py".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/waybar/overview-waybar.py";

  # Neovim
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/nvim";

  # Walker
  xdg.configFile."walker/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/walker/config.toml";

  # Tealdear (tldr)
  xdg.configFile."tealdeer/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/tealdeer/config.toml";
}
