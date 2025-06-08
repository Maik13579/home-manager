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

  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
