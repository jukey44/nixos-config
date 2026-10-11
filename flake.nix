{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-26.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    opendeck.url = "github:Kitt3120/opendeck-nix";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    };
    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite/v0.8.3";
      inputs.nixpkgs.follows = "nixpkgs";    
    };
   };
  
  outputs = { self, nixpkgs, opendeck,  ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.kyle = nixpkgs.lib.nixosSystem {
     specialArgs = { inherit inputs; };  # ← add this line
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./hosts/kyle/configuration.nix
        ./hosts/kyle/noctalia.nix
        { system.configurationRevision = self.rev or self.dirtyRev or null; }
        opendeck.nixosModules.default
      ];
      
    };
  };
}
