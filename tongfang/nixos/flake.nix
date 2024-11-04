{
  description = "TongFang NixOS flake";

  inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.tongfang = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
      specialArgs = { inherit inputs; };
    };
  };
}