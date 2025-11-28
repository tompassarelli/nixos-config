{
  description = "NixOS Configuration - Modular and Shareable";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-25.05";
    nur.url = "github:nix-community/NUR";

    # Walker and elephant
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, home-manager, stylix, nur, elephant, walker }: {
    # Reusable system builder function
    lib.mkSystem = {
      hostname,
      chosenTheme,
      hostConfig,  # New: path to host-specific configuration
      system ? "x86_64-linux"  # For ARM: use "aarch64-linux"
    }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit chosenTheme;
        inputs = { inherit nur walker elephant; };
      };
      modules = [
        ./hardware-configuration.nix

        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager

        # ============ HOST CONFIGURATION ============
        hostConfig  # Import host-specific module enables

        # ============ COMMON INFRASTRUCTURE ============
        ({ config, ... }: {
          networking.hostName = hostname;

          # Import all modules
          imports = [
            ./modules/boot
            ./modules/terminal
            ./modules/shell
            ./modules/git
            ./modules/yazi
            ./modules/mako
            ./modules/gtk
            ./modules/kanata
            ./modules/users
            ./modules/networking
            ./modules/styling
            ./modules/timezone
            ./modules/nix-settings
            ./modules/ssh
            ./modules/auto-upgrade
            ./modules/audio
            ./modules/bluetooth
            ./modules/niri
            ./modules/input
            ./modules/power
            ./modules/security
            ./modules/theming
            ./modules/tree
            ./modules/dust
            ./modules/eza
            ./modules/procs
            ./modules/tealdeer
            ./modules/fastfetch
            ./modules/btop
            ./modules/rust
            ./modules/development
            ./modules/web-browser
            ./modules/steam
            ./modules/neovim
            ./modules/doom-emacs
            ./modules/productivity
            ./modules/creative
            ./modules/media
            ./modules/password
            ./modules/mail
            ./modules/rofi
            ./modules/walker
            ./modules/waybar
            ./modules/ironbar
            ./modules/framework
            ./modules/claude
            ./modules/theme-switcher
            ./modules/via
          ];

          # System state version
          system.stateVersion = "25.05";

          # Home-manager configuration
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit chosenTheme;
            inputs = { inherit nur walker elephant; };
          };
          home-manager.users.${config.myConfig.users.username} = {
            home.stateVersion = "25.05";
            nixpkgs.config.allowUnfree = true;
          };
        })

        # unstable & master overlays
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
              master = import nixpkgs-master {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
        }
      ];
    };

    # System configurations
    nixosConfigurations = {
      whiterabbit = self.lib.mkSystem {
        hostname = "whiterabbit";
        hostConfig = ./hosts/whiterabbit/configuration.nix;
        # run switch-theme to change themes
        # chosenTheme = "everforest-dark-hard";
        chosenTheme = "tokyo-night-dark";
      };

      thinkpad-x1e = self.lib.mkSystem {
        hostname = "thinkpad-x1e";
        hostConfig = ./hosts/thinkpad-x1e/configuration.nix;
        chosenTheme = "tokyo-night-dark";
      };
    };
  };
}
