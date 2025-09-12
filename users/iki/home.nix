{
  pkgs,
  nixvim_pkg,
  ...
}:

let
  # Flake path for your ROS shells (must be a flake)
  rosFlake = "path:${../../ros2}";

  # Declare wrappers: { name = installed script; attr = devShell attr }
  rosWrappers = [
    {
      name = "ros2";
      attr = "default";
    }
    {
      name = "rviz2";
      attr = "rviz2";
    }
    {
      name = "rqt";
      attr = "rqt";
    }
  ];

  # Build a home.file entry for each wrapper
  mkRosWrapper = pair: {
    name = ".local/bin/${pair.name}";
    value = {
      text = ''
        #!/usr/bin/env bash
        exec nix develop ${rosFlake}#${pair.attr}
      '';
      executable = true;
    };
  };
in
{
  home.username = "iki";
  home.homeDirectory = "/home/iki";

  programs = (import ./programs { inherit pkgs; });
  home.packages = import ./packages.nix { inherit pkgs; } ++ [
    nixvim_pkg
  ];

  fonts.fontconfig.enable = true;

  # Files to place under $HOME
  home.file =
    {
      ".local/bin/repo2promt.sh".source = ../../scripts/repo2promt.sh;
    }
    # add generated ROS wrappers
    // builtins.listToAttrs (map mkRosWrapper rosWrappers);

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Home Manager state version
  home.stateVersion = "24.11";
}
