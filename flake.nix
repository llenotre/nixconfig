{
  description = "llenotre's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { nixpkgs, home-manager, zen-browser, ... }:
  let
    mkSystem = {
      username,
      hostname,
      extraModules ? []
    }:
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit username hostname zen-browser; };
      modules = [
        ./hosts/${hostname}/configuration.nix
        home-manager.nixosModules.home-manager

        ./modules/system.nix
        ./modules/home.nix
        ./modules/zen.nix
      ]
      ++ extraModules;
    };
  in
  {
    nixosConfigurations = {
      gustave = mkSystem {
        username = "luc";
        hostname = "Gustave";
        extraModules = [
          ./modules/game.nix
          ./modules/laptop.nix
          ./modules/perso.nix
        ];
      };
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
