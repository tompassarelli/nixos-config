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
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix }: {
    nixosConfigurations.whiterabbit = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.tom = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }
        
        # unstable overlay
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
            })
          ];
        }
      ];
    };
  };
}
