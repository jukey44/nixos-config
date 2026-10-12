{
  description = "NixOS: desktop (kyle) and laptop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite/v0.8.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opendeck.url = "github:Kitt3120/opendeck-nix";   # desktop only
  };

  outputs = { self, nixpkgs, home-manager, opendeck, ... }@inputs: {
    nixosConfigurations = {

      # Desktop PC
      kyle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
          ./hosts/kyle/configuration.nix
          ./hosts/kyle/noctalia.nix
          opendeck.nixosModules.default

          # Turn this on once home/desktop.nix exists:
          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.backupFileExtension = "backup";
          #   home-manager.extraSpecialArgs = { inherit inputs; };
          #   home-manager.users.kyle = import ./home/desktop.nix;
          # }
        ];
      };

      # Laptop
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
          ./hosts/laptop/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.kyle = import ./home/laptop.nix;
          }
        ];
      };
    };
  };
}
