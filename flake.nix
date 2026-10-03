{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
    mkPkgs = system: import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "terraform"
          "claude-code"
        ];
    };

  mkHome = { system ? "x86_64-linux", host }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs system;

      extraSpecialArgs = { inherit inputs; };

      modules = [ ./hosts/${host}.nix ];
    };
  in {
    homeConfigurations = {
      "paulo@laptop" = mkHome { host = "laptop"; };
      # "paulo@work" = mkHome { host = "work"; };
    };
  };
}
