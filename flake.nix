# Referencing https://github.com/nix-community/home-manager/pull/1697/files
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-home = {
      url = "github:houstdav000/nix-home";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-home }@inputs:
    let
      defFlakeSystem = baseCfg:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Add home-manager to all configs
            ({ ... }: {
              imports = [
                {
                  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
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
    in {
      nixosConfigurations = {
        inherit nixpkgs;

        dh-laptop2 = defFlakeSystem {
          imports = [
            ./configuration.nix

            # Add home-manager config
            { home-manager.users.david = nix-home.nixosModules.desktop; }
          ];
        };
    };
  };
}
