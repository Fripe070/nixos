{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    identity = import ./identity.nix;
  in
  {
    nixosConfigurations = {
      laptop = inputs.nixpkgs.lib.nixosSystem {
        modules = [ ./hosts/laptop.nix ];
        specialArgs = { inherit inputs identity; };
      };
    };
  };
}
