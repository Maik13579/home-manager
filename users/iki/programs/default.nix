{ pkgs, ... }:
{
  bash = (import ./bash.nix { inherit pkgs; });
  btop = (import ./btop.nix { inherit pkgs; });
  dircolors = (import ./dircolors.nix { inherit pkgs; });
  eza = (import ./eza.nix { inherit pkgs; });
  git = (import ./git.nix { inherit pkgs; });
  home-manager = (import ./home-manager.nix { inherit pkgs; });
  lazydocker = (import ./lazydocker.nix { inherit pkgs; });
  lazygit = (import ./lazygit.nix { inherit pkgs; });
  starship = (import ./starship.nix { inherit pkgs; });
  terminator = (import ./terminator.nix { inherit pkgs; });
}
