# nix/dev-shell.nix
{
  pkgs,
  rosPkgs,
  rosDistro,
  ros2nixPkg,
}:

let
  # Ros packages installed in shell
  ros-env =
    with rosPkgs;
    buildEnv {
      name = "ros-env-${rosDistro}";
      paths = [
        ros-core
        rmw-cyclonedds-cpp
        ros2bag
        rosbag2-storage-mcap
        rviz2
        rqt-tf-tree
        rqt-reconfigure
        rqt-common-plugins
      ];
    };

  # packages installed in shell
  deps = [
    ros2nixPkg
    ros-env # contains all ros packages from above
    pkgs.cyclonedds
    pkgs.python3Packages.argcomplete
  ];

  # helper function to create dev shell
  makeShell =
    {
      name,
      extraShellHock ? "",
    }:
    pkgs.mkShell {
      name = "${name}-${rosDistro}";
      packages = deps;

      ROS_DOMAIN_ID = "99";
      RMW_IMPLEMENTATION = "rmw_cyclonedds_cpp";

      shellHook = ''
        # for autocomplete
        eval "$(register-python-argcomplete ros2)"
        eval "$(register-python-argcomplete colcon)"

        #wrapper for graphical tools
        graphical() {
          NIXPKGS_ALLOW_UNFREE=1 \
          QT_QPA_PLATFORM=xcb \
          nix run --impure github:guibou/nixGL -- "$@"
        }
        alias rviz2="graphical rviz2"
        alias rqt="graphical rqt"

        ${extraShellHock}
      '';
    };
in
{
  default = makeShell {
    name = "ros2";
    extraShellHock = "";
  };

  rviz2 = makeShell {
    name = "rviz2";
    extraShellHock = "graphical rviz2";
  };

  rqt = makeShell {
    name = "rqt";
    extraShellHock = "graphical rqt";
  };
}
