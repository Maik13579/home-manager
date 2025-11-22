{
  pkgs,
  nixvim_pkg,
  ...
}:
{
  home.username = "iki";
  home.homeDirectory = "/home/iki";

  programs = (import ./programs { inherit pkgs; });
  home.packages = import ./packages.nix { inherit pkgs; } ++ [
    nixvim_pkg
  ];

  fonts.fontconfig.enable = true;

  # Files to place under $HOME
  home.file = {
    ".local/bin/repo2promt.sh".source = ../../scripts/repo2promt.sh;
    ".config/bash/clone.bash".source = ../../scripts/clone.bash;
    ".config/bash/drun.bash".source = ../../scripts/drun.bash;
    ".dotfiles/.bashrc".source = ../../dotfiles/bashrc;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Home Manager state version
  home.stateVersion = "24.11";
}
