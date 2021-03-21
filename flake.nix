# Referencing https://github.com/nix-community/home-manager/pull/1697/files
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-home = {
      url = "github:houstdav000/nix-home";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-home, flake-utils }@inputs:
    let
      defFlakeSystem = baseCfg:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Add home-manager to all configs
            ({ pkgs, lib, ... }: {
              imports = [
                { system.stateVersion = "21.05"; }
                {
                  nix = {
                    package = pkgs.nixFlakes;
                    extraOptions = ''
                      experimental-features = nix-command flakes
                    '';
                    nixPath = [ "nixpkgs=${nixpkgs}" ];
                    registry.nixpkgs.flake = nixpkgs;
                  };
                }
                baseCfg
                home-manager.nixosModules.home-manager
                { home-manager.useUserPackages = true; }
              ];
              system.configurationRevision =
                nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = nixpkgs;
            })
          ];
        };
    in flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        devShell = pkgs.mkShell { nativeBuildInputs = with pkgs; [ nixfmt ]; };
      }) // {
        nixosConfigurations = {
          dh-laptop2 = defFlakeSystem {
            imports = [
              ./hosts/dh-laptop2.nix
              ./users/david.nix

              # Add home-manager config
              ({ ... }: {
                home-manager.users.david = nix-home.nixosModules.desktop;
              })
            ];
          };
        };
      };
}
