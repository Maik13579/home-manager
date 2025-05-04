{ ... }:
{
  enable = true;
  enableCompletion = true;
  historySize = 100000;
  bashrcExtra = ''
    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize



    export TERM=xterm-256color


    export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    export ROS_DOMAIN_ID=99
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    export EDITOR=nvim

    reset_audio(){
      pulseaudio -k && sudo alsa force-reload
    }
  '';

  shellAliases = {
    dev = "nix develop";
    ls = "eza";
    ll = "eza -la";
    tree = "eza -T";
    hms = "home-manager switch";
    lg = "lazygit";
    nv = "nvim .";
  };
}
