{ pkgs, ... }:
{
  bash = (import ./home-manager-auto-expire.nix { inherit pkgs; });
}
