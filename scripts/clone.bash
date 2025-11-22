#!/usr/bin/env bash
export IKI_GITLAB_GROUP_URL=https://gitlab.rwu.de/prj-iki-ros2/pkgs
export IKI_TOKEN=$IKIPKG_TOKEN

: "${IKI_GITLAB_CACHE_FILE:=$HOME/.cache/iki-gitlab/repos.txt}"

iki-gitlab-refresh() {
  if [[ -z "${IKI_GITLAB_GROUP_URL:-}" ]]; then
    echo "Error: IKI_GITLAB_GROUP_URL is not set." >&2
    return 1
  fi

  if [[ -z "${IKI_TOKEN:-}" ]]; then
    echo "Error: IKI_TOKEN is not set." >&2
    return 1
  fi

  if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required to refresh repo cache." >&2
    return 1
  fi

  local group_url base_url group_path group_id_enc per_page tmp_file

  group_url="${IKI_GITLAB_GROUP_URL%/}"
  base_url="$(printf '%s\n' "$group_url" | sed -E 's#(https?://[^/]+).*#\1#')"
  group_path="$(printf '%s\n' "$group_url" | sed -E 's#https?://[^/]+/##')"

  urlencode_group_path() {
    local p="$1"
    printf '%s' "${p//\//%2F}"
  }

  group_id_enc="$(urlencode_group_path "$group_path")"
  per_page="${IKI_PER_PAGE:-200}"
  tmp_file="$(mktemp)"

  curl --silent --show-error \
    --header "PRIVATE-TOKEN: $IKI_TOKEN" \
    "$base_url/api/v4/groups/$group_id_enc/projects?per_page=$per_page&simple=true" \
    | jq -r '.[].path' | sort -u > "$tmp_file"

  mkdir -p "$(dirname "$IKI_GITLAB_CACHE_FILE")"
  mv "$tmp_file" "$IKI_GITLAB_CACHE_FILE"
}

_iki_gitlab_clone_single() {
  local repo_name="$1"

  local group_url git_host group_path clone_url
  group_url="${IKI_GITLAB_GROUP_URL%/}"
  git_host="$(printf '%s\n' "$group_url" | sed -E 's#https?://([^/]+)/?.*#\1#')"
  group_path="$(printf '%s\n' "$group_url" | sed -E 's#https?://[^/]+/##')"

  clone_url="git@${git_host}:${group_path}/${repo_name}.git"

  if [[ -d "$repo_name/.git" ]]; then
    echo "skip: $repo_name already cloned"
    return 0
  fi

  echo "clone: $clone_url"
  git clone "$clone_url"
}

_iki_gitlab_clone_recursive() {
  local repo_name="$1"

  # VISITED and REPO_SET come from outer iki-gitlab-clone scope
  if [[ -n "${VISITED[$repo_name]:-}" ]]; then
    return 0
  fi
  VISITED["$repo_name"]=1

  _iki_gitlab_clone_single "$repo_name"

  local pkg_xml="$repo_name/package.xml"
  if [[ ! -f "$pkg_xml" ]]; then
    return 0
  fi

  local dep
  while IFS= read -r dep; do
    dep="${dep#"${dep%%[![:space:]]*}"}"
    dep="${dep%"${dep##*[![:space:]]}"}"
    [[ -z "$dep" ]] && continue
    [[ -z "${REPO_SET[$dep]:-}" ]] && continue
    _iki_gitlab_clone_recursive "$dep"
  done < <(sed -n 's/.*<depend[^>]*>\([^<]*\)<\/depend>.*/\1/p' "$pkg_xml")
}

iki-gitlab-clone() {
  local cache_file
  cache_file="${IKI_GITLAB_CACHE_FILE:-$HOME/.cache/iki-gitlab/repos.txt}"

  # parse flags
  local recursive=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -r|--recursive)
        recursive=true
        shift
        ;;
      --list)
        if [[ -r "$cache_file" ]]; then
          cat "$cache_file"
        fi
        return 0
        ;;
      -h|--help)
        echo "Usage: iki-gitlab-clone [-r|--recursive] <repo-name>"
        echo "       iki-gitlab-clone --list"
        echo
        echo "  -r, --recursive   clone repo and its local deps from package.xml"
        return 0
        ;;
      *)
        break
        ;;
    esac
  done

  if [[ -z "${IKI_GITLAB_GROUP_URL:-}" ]]; then
    echo "Error: IKI_GITLAB_GROUP_URL is not set." >&2
    return 1
  fi

  if [[ "$#" -lt 1 ]]; then
    echo "Error: missing repo name" >&2
    return 1
  fi

  local repo_name="$1"

  if [[ "$recursive" == false ]]; then
    _iki_gitlab_clone_single "$repo_name"
    return
  fi

  # recursive mode: build repo set from cache and walk deps
  if [[ ! -r "$cache_file" ]]; then
    echo "Error: cache file not found: $cache_file" >&2
    echo "Run: iki-gitlab-refresh" >&2
    return 1
  fi

  local repo
  declare -A REPO_SET
  declare -A VISITED

  while IFS= read -r repo; do
    [[ -n "$repo" ]] && REPO_SET["$repo"]=1
  done < "$cache_file"

  _iki_gitlab_clone_recursive "$repo_name"
}

_iki_gitlab_clone_complete() {
  local cur repos
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  repos="$(iki-gitlab-clone --list 2>/dev/null || true)"

  COMPREPLY=( $(compgen -W "${repos}" -- "$cur") )
}

complete -r iki-gitlab-clone 2>/dev/null
complete -F _iki_gitlab_clone_complete iki-gitlab-clone

