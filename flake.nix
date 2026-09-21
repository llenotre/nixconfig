{
  description = "llenotre's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    mkSystem = {
      username,
      hostname,
      extraModules ? []
    }:
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit username hostname; };
      modules = [
        ./hosts/${hostname}/configuration.nix
        home-manager.nixosModules.home-manager

        ./modules/system.nix
        ./modules/home.nix
      ]
      ++ extraModules;
    };
  in
  {
    nixosConfigurations = {
      work = mkSystem {
        username = "luc";
        hostname = "CC-Luc";
        extraModules = [
          ./modules/laptop.nix
          ./modules/work.nix
        ];
      };
    };
  };
}
