# drun: docker run with /pkgs bind, always start bash
drun() {
  if [[ $# -lt 1 ]]; then
    echo "usage: drun [docker run options] IMAGE"
    return 1
  fi
  docker run --rm -it -v /pkgs:/pkgs "$@" bash
}

# Completion: delegate to Docker's "run" completion (fixes repeated TAB)
_drun_completion() {
  # save originals
  local SAVE_WORDS=("${COMP_WORDS[@]}")
  local SAVE_CWORD=$COMP_CWORD
  local SAVE_LINE=$COMP_LINE
  local SAVE_POINT=$COMP_POINT

  # compute index of first space
  local sp=-1
  if [[ "$SAVE_LINE" == *" "* ]]; then
    local before="${SAVE_LINE%% *}"
    sp=${#before}   # number of chars before first space (0-based index of space)
  fi

  # translated line and point
  local prefix="docker run"
  local tail=""
  if (( sp >= 0 )); then
    tail="${SAVE_LINE:sp}"   # includes the space
  fi
  COMP_LINE="$prefix$tail"

  local prefix_len=${#prefix}
  if (( sp < 0 || SAVE_POINT <= sp )); then
    COMP_POINT=$prefix_len
  else
    local after=$(( SAVE_POINT - sp ))
    COMP_POINT=$(( prefix_len + after ))
  fi

  # translated words/cword
  COMP_WORDS=(docker run "${SAVE_WORDS[@]:1}")
  COMP_CWORD=$(( SAVE_CWORD + 1 ))

  # call docker's completer
  if declare -F __start_docker >/dev/null 2>&1; then
    __start_docker
  elif declare -F _docker >/dev/null 2>&1; then
    _docker
  fi

  # restore
  COMP_WORDS=("${SAVE_WORDS[@]}")
  COMP_CWORD=$SAVE_CWORD
  COMP_LINE=$SAVE_LINE
  COMP_POINT=$SAVE_POINT
}
complete -o default -o bashdefault -F _drun_completion drun

