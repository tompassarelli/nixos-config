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

    # Doom Emacs
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, home-manager, stylix, nur, elephant, walker, nix-doom-emacs-unstraightened }: {
    # Reusable system builder function
    lib.mkSystem = {
      hostname,
      username,
      chosenTheme,
      system ? "x86_64-linux"  # For ARM: use "aarch64-linux"
    }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit username chosenTheme;
        inputs = { inherit nur walker elephant nix-doom-emacs-unstraightened; };
      };
      modules = [
        ./hardware-configuration.nix

        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager

        # ============ CONFIGURATION ============
        {
          networking.hostName = hostname;
          # Module enable flags - single source of truth
          myConfig = {
            # Hardware
            framework.enable = true; # for framework computers
            via.enable = false; # custom keyboard firmware
            audio.enable = true;
            bluetooth.enable = true;

            input.enable = true; # needed for kanata
            kanata = {
              enable = true;
              capsLockEscCtrl = true;
              leftAltAsSuper = true;
              wideMod = true; # shifts QWERTY right hand 1 key right
              #spacebarAsMeh = false; # needs work
            };

            # System
            nix-settings.enable = true;
            boot.enable = true;
            users.enable = true;
            networking.enable = true;
            timezone.enable = true;
            ssh.enable = true;
            auto-upgrade.enable = true;

            # Terminal
            terminal.enable = true;
            shell.enable = true;

            # Utils
            yazi.enable = true;
            tree.enable = true;
            dust.enable = true;
            eza.enable = true;
            procs.enable = true;
            tealdeer.enable = true;
            fastfetch.enable = true;
            btop.enable = true;

            # Desktop Environment
            niri.enable = true;
            power.enable = true;
            security.enable = true;
            rofi-wayland.enable = false;
            walker.enable = true;
            waybar.enable = false;
            ironbar.enable = true;
            mako.enable = true;
            # Desktop Environment - Themes
            gtk.enable = true;
            styling.enable = true;
            theming.enable = true;
            theme-switcher.enable = true;

            # Development 
            git.enable = true;
            rust = {
              enable = true;
              bevy = true;
            };
            development.enable = true;
            claude.enable = true;

            # GUI applications
            web-browser = {
              enable = true;
              fennec.enable = true;
              chrome.enable = true;
            };
            steam.enable = true;
            neovim.enable = true;
            doom-emacs.enable = true;
            productivity.enable = true;
            creative.enable = true;
            media.enable = true;
            password.enable = true;
            mail.enable = true;
          };

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
            inherit username chosenTheme;
            inputs = { inherit nur walker elephant nix-doom-emacs-unstraightened; };
          };
          home-manager.users.${username} = {
            home.stateVersion = "25.05";
            nixpkgs.config.allowUnfree = true;
          };
        }
        
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

    # Example system configurations
    nixosConfigurations = {
      whiterabbit = self.lib.mkSystem {
        hostname = "whiterabbit";
        username = "tom";
        # run switch-theme to change themes
        chosenTheme = "everforest-dark-hard";
        # system = "aarch64-linux";  # Uncomment for ARM systems
        # many default modules will not work on ARM, vaporware!
      };
    };
  };
}
