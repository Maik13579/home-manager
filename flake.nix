{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:maik13579/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pkgs-utils.url = "git+ssh://git@gitlab.rwu.de/prj-iki-ros2/pkgs/pkgs_utils.git?ref=main";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      pkgs-utils,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      nixvim_pkg = nixvim.packages.${system}.default;
      ikiPkgs = pkgs-utils.packages.${system};
    in
    {
      homeConfigurations."iki" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./users/iki/home.nix ];
        extraSpecialArgs = { inherit nixvim_pkg ikiPkgs; };
      };
    };
}
