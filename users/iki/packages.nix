{ pkgs, nixvim_pkg, ... }:
with pkgs;
[
  nixvim_pkg
  alejandra # nix format
  nixd # lsp

  lazygit
  xclip

  nerd-fonts.jetbrains-mono
  neofetch
  nnn # terminal file manager

  clang
  clang-tools

  # archives
  zip
  xz
  unzip
  p7zip

  # utils
  ripgrep # recursively searches directories for a regex pattern
  yq-go # yaml processor https://github.com/mikefarah/yq
  eza # A modern replacement for ‘ls’
  fzf # A command-line fuzzy finder

  # misc
  file
  which

  # nix related
  #
  # it provides the command `nom` works just like `nix`
  # with more details log output
  nix-output-monitor

  glow # markdown previewer in terminal

  btop # replacement of htop/nmon
  iotop # io monitoring
  iftop # network monitoring

  # system call monitoring
  strace # system call monitoring
  ltrace # library call monitoring
  lsof # list open files

  # system tools
  sysstat
  lm_sensors # for `sensors` command
  ethtool
  pciutils # lspci
  usbutils # lsusb
]
