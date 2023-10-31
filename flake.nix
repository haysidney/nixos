{

  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      zephyrus = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          #./zephyrus.nix
          ./configuration.nix
          #./i3.nix
          #./sway.nix
          #./dwm.nix
          #./plasma.nix
          #./icewm.nix
          #./wayfire.nix
          #./hyprland.nix
        ];
      };
    };
  };

}
