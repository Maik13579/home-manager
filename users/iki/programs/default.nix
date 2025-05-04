{ pkgs, ... }:
{
  git = (import ./git.nix { inherit pkgs; });
  bash = (import ./bash.nix { inherit pkgs; });
  dircolors = (import ./dircolors.nix { inherit pkgs; });
  terminator = (import ./terminator.nix { inherit pkgs; });
  home-manager = (import ./home-manager.nix { inherit pkgs; });
  starship = (import ./starship.nix { inherit pkgs; });
}

