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

    nv() {
      if [ $# -eq 0 ]; then
        nvim .
      else
        nvim "$1"
      fi
    }

    dev() {
      case $# in
        0)
          # No args: develop current flake
          nix develop ./
          ;;
        1)
          # One arg: path to flake
          cd "$1" || return
          nix develop ./
          cd --
          ;;
        2)
          # Two args: path + ref
          cd "$1" || return
          nix develop .#"$2"
          cd --
          ;;
        *)
          echo "Usage: dev [path] [ref]" >&2
          return 1
          ;;
      esac
    }


    # Workspace commands
    activate_workspace() {
      # Create or update the ~/.workspace symlink to the current directory
      ln -sfn "$(pwd)" ~/.workspace
    }

    disable_workspace() {
      # Remove the symlink only if it exists
      [ -e ~/.workspace ] && rm ~/.workspace
    }

    # Enter the workspace only if the symlink exists
    [ -e ~/.workspace ] && cd -P ~/.workspace



    # Nix commands
    nix_tree(){
      if [ $# -eq 0 ]; then
        nix run github:craigmbooth/nix-visualize -- result
      else
        nix run github:craigmbooth/nix-visualize -- "$1"
      fi

      feh frame.png
      rm frame.png
    }

    nix_size(){
      if [ $# -eq 0 ]; then
        nix-store -qR result   | xargs du -hd0 -c   | sort -h
      else
        nix-store -qR "$1"   | xargs du -hd0 -c   | sort -h
      fi
    }

    nix_add_root(){
      if [ $# -lt 2 ]; then
        echo "Usage: nix_add_root [path] [pkg]"
        echo "Creates a symlink at [path] pointing to [pkg] that keeps the package safe from garbage collect as long as the symlink is alive"
      else
        nix-store --add-root "$1" --indirect -r "$2"
      fi
    }

    nix_print_root(){
      eza -l --no-user --no-filesize --no-permissions -h /nix/var/nix/gcroots/auto/
    }

    #source iki token
    [ -e ~/.config/.ikitoken ] && source ~/.config/.ikitoken


    # make sure this dir exists
    mkdir -p /tmp/test

  '';

  shellAliases = {
    hms = "home-manager switch";
    lg = "lazygit";
    good_commit = "curl -s https://whatthecommit.com/index.txt";
    run = "nix run";
    show = "nix flake show";
    build = "nix build";
  };
}
