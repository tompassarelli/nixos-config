{ inputs, pkgs, modulesPath, ... }:

{
  # Disable home-manager's built-in anyrun module to avoid conflicts
  disabledModules = ["${modulesPath}/programs/anyrun.nix"];
  
  # Import the anyrun flake's home-manager module
  imports = [ inputs.anyrun.homeManagerModules.default ];

  programs.anyrun = {
    enable = true;
    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
      
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.niri-focus
        inputs.anyrun.packages.${pkgs.system}.applications
      ];
      
      keybinds = [
        # Default keybinds
        { key = "Return"; action = "select"; }
        { key = "Escape"; action = "close"; }
        { key = "Up"; action = "up"; }
        { key = "Down"; action = "down"; }
        { key = "Tab"; action = "down"; }
        { key = "ISO_Left_Tab"; action = "up"; }
        # Vim-style navigation
        { key = "j"; ctrl = true; action = "down"; }
        { key = "k"; ctrl = true; action = "up"; }
      ];
    };
  };
}
