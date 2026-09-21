{
  description = "llenotre's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
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
        ./modules/system.nix
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
