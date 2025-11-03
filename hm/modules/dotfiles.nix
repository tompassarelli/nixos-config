{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.dotfiles;
in
{
  options.myConfig.dotfiles = {
    enable = lib.mkEnableOption "Dotfiles management";
  };

  config = lib.mkIf cfg.enable {
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

  # Neovim - symlink individual files like waybar
  xdg.configFile."nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/nvim/init.lua";
  
  # Generate stylix colors for neovim (based on stylix neovim.nix)
  xdg.configFile."nvim/lua/stylix-colors.lua".text = with config.lib.stylix.colors; ''
    local M = {}
    
    -- Base16 color palette
    M.palette = {
      base00 = "#${base00}",
      base01 = "#${base01}",
      base02 = "#${base02}",
      base03 = "#${base03}",
      base04 = "#${base04}",
      base05 = "#${base05}",
      base06 = "#${base06}",
      base07 = "#${base07}",
      base08 = "#${base08}",
      base09 = "#${base09}",
      base0A = "#${base0A}",
      base0B = "#${base0B}",
      base0C = "#${base0C}",
      base0D = "#${base0D}",
      base0E = "#${base0E}",
      base0F = "#${base0F}"
    }
    
    -- Stylix colorscheme setup function (adapted from stylix neovim.nix)
    M.setup = function()
      -- Try to use mini.base16 if available, fallback to manual highlights
      local ok, mini_base16 = pcall(require, 'mini.base16')
      if ok then
        mini_base16.setup({ palette = M.palette })
      else
        -- Manual highlight setup as fallback
        vim.cmd.highlight({ "Normal", "guifg=" .. M.palette.base05, "guibg=" .. M.palette.base00 })
        vim.cmd.highlight({ "Comment", "guifg=" .. M.palette.base03 })
        vim.cmd.highlight({ "String", "guifg=" .. M.palette.base0B })
        vim.cmd.highlight({ "Keyword", "guifg=" .. M.palette.base0E })
        vim.cmd.highlight({ "Function", "guifg=" .. M.palette.base0D })
        vim.cmd.highlight({ "Type", "guifg=" .. M.palette.base0A })
        vim.cmd.highlight({ "Constant", "guifg=" .. M.palette.base09 })
        vim.cmd.highlight({ "Error", "guifg=" .. M.palette.base08 })
        -- Add transparency if desired
        -- vim.cmd.highlight({ "Normal", "guibg=NONE", "ctermbg=NONE" })
      end
    end
    
    return M
  '';

  # Walker
  xdg.configFile."walker/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/walker/config.toml";

  # Tealdear (tldr)
  xdg.configFile."tealdeer/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/tealdeer/config.toml";

    # Themes directory
    xdg.configFile."themes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixos-config/dotfiles/themes";
  };
}
