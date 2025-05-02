{ pkgs, ... }:
{
    git = (import ./git.nix { inherit pkgs; });
    bash = (import ./bash.nix { inherit pkgs; });
    dircolors = (import ./dircolors.nix { inherit pkgs; });
    terminator = (import ./terminator.nix { inherit pkgs; });
    home-manager.enable = true;
    starship = (import ./starship.nix { inherit pkgs; });
}