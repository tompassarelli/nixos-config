{
  description = "NixOS Configuration - Modular and Shareable";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-25.05";
    anyrun.url = "github:anyrun-org/anyrun";
    anyrun-rename-workspace.url = "github:tompassarelli/anyrun-rename-workspace";
    nur.url = "github:nix-community/NUR";
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, anyrun, anyrun-rename-workspace, nur }: {
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
        inputs = { inherit anyrun anyrun-rename-workspace nur; };
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
            # Hardware-specific (set to false if not using Framework)
            framework.enable = true;

            # Core system modules
            boot.enable = true;
            terminal.enable = true;
            shell.enable = true;
            git.enable = true;
            yazi.enable = true;
            mako.enable = true;
            gtk.enable = true;
            anyrun.enable = false;
            kanata = {
              enable = true;
              capsLockEscCtrl = true;
              leftAltAsSuper = true;
              wideMod = true;
            };
            users.enable = true;
            networking.enable = true;
            styling.enable = true;
            timezone.enable = true;
            nix-settings.enable = true;
            ssh.enable = true;

            # Desktop environment
            audio.enable = true;
            niri.enable = true;
            input.enable = true;
            power.enable = true;
            security.enable = true;
            theming.enable = true;

            # CLI utilities
            tree.enable = true;
            dust.enable = true;
            eza.enable = true;
            procs.enable = true;
            tealdeer.enable = true;
            fastfetch.enable = true;
            btop.enable = true;

            # Development and tools
            rust.enable = true;
            development.enable = true;

            # Applications
            web-browser = {
              enable = true;
              fennec.enable = true;
              chromium.enable = false;
            };
            steam.enable = true;
            neovim.enable = true;
            productivity.enable = true;
            creative.enable = true;
            media.enable = true;
            password.enable = true;
            mail.enable = true;
            rofi-wayland.enable = true;
            walker.enable = true;
            waybar.enable = true;
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
            ./modules/anyrun
            ./modules/kanata
            ./modules/users
            ./modules/networking
            ./modules/styling
            ./modules/timezone
            ./modules/nix-settings
            ./modules/ssh
            ./modules/audio
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
            ./modules/productivity
            ./modules/creative
            ./modules/media
            ./modules/password
            ./modules/mail
            ./modules/rofi
            ./modules/walker
            ./modules/waybar
            ./modules/framework
          ];

          # System state version
          system.stateVersion = "25.05";

          # Home-manager configuration
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit username chosenTheme;
            inputs = { inherit anyrun anyrun-rename-workspace nur; };
          };
          home-manager.users.${username} = {
            home.stateVersion = "25.05";
            nixpkgs.config.allowUnfree = true;
          };
        }
        
        # unstable overlay
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
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
        chosenTheme = "tokyo-night-dark";
        # system = "aarch64-linux";  # Uncomment for ARM systems
        # as of 11/02/2025 many default modules will not work on ARM
      };
    };
  };
}
