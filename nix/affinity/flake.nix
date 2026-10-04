{
  description = "Standalone affinity-nix install (binary cache, no build-from-source wine)";

  nixConfig = {
    extra-substituters = [ "https://cache.forall.systems" ];
    extra-trusted-public-keys = [
      "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, affinity-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ affinity-nix.overlays.default ];
        config.allowUnfree = true;
      };
    in
    {
      packages.${system} = {
        inherit (pkgs) affinity-v3 affinity-photo affinity-designer affinity-publisher;
        default = pkgs.affinity-v3;
      };
    };
}
