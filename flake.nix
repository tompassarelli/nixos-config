{
  description = "Firn - A modular, shareable NixOS configuration framework";

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

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, home-manager, stylix, nur, elephant, walker }:
    let
      # All available modules - can be imported by external configs
      firnModules = ./modules;
    in {
    # ============================================================
    # PUBLIC API: Use these from your own flake
    # ============================================================

    # Reusable system builder function
    #
    # Usage from external flake:
    #   nixos-config.lib.mkSystem {
    #     hostname = "my-machine";
    #     hostConfig = ./hosts/my-machine/configuration.nix;
    #     hardwareConfig = ./hosts/my-machine/hardware-configuration.nix;
    #   }
    #
    lib.mkSystem = {
      hostname,
      hostConfig,
      hardwareConfig,
      system ? "x86_64-linux",
      extraModules ? [],
      extraOverlays ? [],
      extraSpecialArgs ? {},
    }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inputs = { inherit nur walker elephant; };
      } // extraSpecialArgs;
      modules = [
        hardwareConfig

        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager

        # Host-specific configuration (module enables, username, etc.)
        hostConfig

        # ============ FIRN MODULES ============
        ({ config, ... }: {
          networking.hostName = hostname;

          imports = [
            "${firnModules}/boot"
            "${firnModules}/terminal"
            "${firnModules}/shell"
            "${firnModules}/git"
            "${firnModules}/yazi"
            "${firnModules}/mako"
            "${firnModules}/gtk"
            "${firnModules}/kanata"
            "${firnModules}/users"
            "${firnModules}/networking"
            "${firnModules}/styling"
            "${firnModules}/timezone"
            "${firnModules}/nix-settings"
            "${firnModules}/ssh"
            "${firnModules}/auto-upgrade"
            "${firnModules}/audio"
            "${firnModules}/bluetooth"
            "${firnModules}/niri"
            "${firnModules}/input"
            "${firnModules}/power"
            "${firnModules}/security"
            "${firnModules}/theming"
            "${firnModules}/tree"
            "${firnModules}/dust"
            "${firnModules}/eza"
            "${firnModules}/procs"
            "${firnModules}/tealdeer"
            "${firnModules}/fastfetch"
            "${firnModules}/btop"
            "${firnModules}/rust"
            "${firnModules}/development"
            "${firnModules}/web-browser"
            "${firnModules}/steam"
            "${firnModules}/neovim"
            "${firnModules}/doom-emacs"
            "${firnModules}/productivity"
            "${firnModules}/creative"
            "${firnModules}/media"
            "${firnModules}/password"
            "${firnModules}/mail"
            "${firnModules}/rofi"
            "${firnModules}/walker"
            "${firnModules}/waybar"
            "${firnModules}/ironbar"
            "${firnModules}/framework"
            "${firnModules}/claude"
            "${firnModules}/theme-switcher"
            "${firnModules}/via"
            "${firnModules}/system"
            "${firnModules}/zed"
            "${firnModules}/printing"
          ];

          # Home-manager configuration
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inputs = { inherit nur walker elephant; };
          } // extraSpecialArgs;
          home-manager.users.${config.myConfig.users.username} = {
            home.stateVersion = config.myConfig.system.stateVersion;
            nixpkgs.config.allowUnfree = true;
          };
        })

        # Overlays: unstable, master, and user-provided
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
          ] ++ extraOverlays;
        }
      ] ++ extraModules;
    };

    # Expose modules path for users who want to import individual modules
    modules = firnModules;

    # ============================================================
    # TOM'S PERSONAL CONFIGURATIONS
    # (Example usage - users create their own in their firn repo)
    # ============================================================

    nixosConfigurations = {
      whiterabbit = self.lib.mkSystem {
        hostname = "whiterabbit";
        hostConfig = ./hosts/whiterabbit/configuration.nix;
        hardwareConfig = ./hardware-configuration.nix;
      };

      thinkpad-x1e = self.lib.mkSystem {
        hostname = "thinkpad-x1e";
        hostConfig = ./hosts/thinkpad-x1e/configuration.nix;
        hardwareConfig = ./hardware-configuration.nix;
      };
    };
  };
}
