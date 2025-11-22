{ ... }:
{
  enable = true;
  enableCompletion = true;
  historySize = 100000;
  bashrcExtra = ''
    source ~/.dotfiles/.bashrc
    [ -e ~/.local_bashrc ] && source ~/.local_bashrc
  '';
}
