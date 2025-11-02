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
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, anyrun }: {
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
      };
      modules = [
        ./system/hardware-configuration.nix
        ./system/configuration.nix
        
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          networking.hostName = hostname;
          home-manager.users.${username} = import ./hm/hm.nix;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { 
            inherit username chosenTheme;
            inputs = { inherit anyrun; };
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
