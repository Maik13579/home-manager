{ pkgs, ... }:
with pkgs;
[
  xclip
  clang
  clang-tools

  nerd-fonts.jetbrains-mono

  neofetch

  # archives
  zip
  xz
  unzip
  p7zip

  # utils
  ripgrep # recursively searches directories for a regex pattern
  yq-go # yaml processor https://github.com/mikefarah/yq
  fzf # A command-line fuzzy finder

  # misc
  file
  which

  # nix related
  #
  # it provides the command `nom` works just like `nix`
  # with more details log output
  nix-output-monitor
  alejandra # nix format
  nixd # lsp

  glow # markdown previewer in terminal

  # system tools
  pciutils # lspci
  usbutils # lsusb
]
