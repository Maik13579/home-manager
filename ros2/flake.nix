{
  description = "ROS2 stuff";

  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    ros2nix = {
      url = "github:wentasah/ros2nix?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-ros-overlay.follows = "nix-ros-overlay";
    };
  };

  outputs =
    {
      self,
      nix-ros-overlay,
      nixpkgs,
      ros2nix,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nix-ros-overlay.overlays.default # add ros packages
        ];
      };

      rosDistro = "jazzy";
      rosPkgs = pkgs.rosPackages.${rosDistro};

      ros2nixPkg = ros2nix.packages.${system}.default;

      devShells = import ./ros-shells.nix {
        inherit
          pkgs
          rosPkgs
          rosDistro
          ros2nixPkg
          ;
      };
    in
    {
      legacyPackages.${system} = rosPkgs;
      devShells.${system} = devShells;
    };

  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
