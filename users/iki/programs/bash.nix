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

    dev() {
      if [ $# -eq 0 ]; then
        nix develop ./
      else
        nix develop ./"$1"
      fi
    }

    show_nix_tree(){
      if [ $# -eq 0 ]; then
        nix run github:craigmbooth/nix-visualize -- result
      else
        nix run github:craigmbooth/nix-visualize -- "$1"
      fi

      feh frame.png
      rm frame.png
    }

    show_nix_size(){
      if [ $# -eq 0 ]; then
        nix-store -qR result   | xargs du -hd0 -c   | sort -h
      else
        nix-store -qR "$1"   | xargs du -hd0 -c   | sort -h
      fi
    }

  '';

  shellAliases = {
    hms = "home-manager switch";
    lg = "lazygit";
    nv = "nvim .";
  };
}
