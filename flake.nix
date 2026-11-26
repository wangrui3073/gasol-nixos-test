{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    colmena.url = "github:nix-community/colmena/v0.5.0";
  };

  outputs =
    { nixpkgs, disko, colmena, ... }:
    let
      system = "x86_64-linux";
      hostName = "nixos-sloth";

      hive = {
        meta.nixpkgs = import nixpkgs { inherit system; };

        ${hostName} = {
          deployment.targetHost = hostName;
          deployment.targetUser = "root";
          deployment.buildOnTarget = false;

          imports = [
            disko.nixosModules.disko
            ./hosts/nixos-sloth/configuration.nix
          ];
        };
      };
    in
    {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          disko.nixosModules.disko
          ./hosts/nixos-sloth/configuration.nix
        ];
      };

      packages.${system}.colmena = colmena.packages.${system}.colmena;

      colmena = hive;
      colmenaHive = colmena.lib.makeHive hive;
    };
}
