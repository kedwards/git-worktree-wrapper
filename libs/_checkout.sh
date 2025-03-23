#!/usr/bin/env bash
# shellcheck disable=SC2164

#
# Functions to wrap git's checkout command in bare repositories
#

# Override checkout commands. Triggered by:
# > git checkout ...
checkout::override_commands() {
  local existing_branch
  case "${2:-}" in
  -b | -B)
    checkout::_create_branch_and_worktree "${@:-}"
    return
    ;;
  .)
    # Simplest file checkout, run vanilla git
    utils::git "${@:-}"
    return
    ;;
  esac

  if [[ -z "${3:-}" ]] && [[ $(utils::is_worktreable "${2:-}") == 1 ]]; then
    checkout::_switch_to_ref_and_worktree "${@:-}"
  else
    if echo "${@:-}" | grep -qo " -"; then
      utils::info "Options other than [-b|-B] are not supported.
            Running vanilla git."
    fi
    utils::git "${@:-}"
  fi
}

# Create or reset a branch/worktree
checkout::_create_branch_and_worktree() {
  local opt="${2:-}" to="${3:-}" from="${4:-}"
  local to_dir existing_branch

  to_dir=$(utils::ref_to_dir_name "${to}")
  existing_branch=$(utils::git branch --list "${to}")

  if [ -n "${existing_branch:-}" ] && [ "$opt" = "-b" ]; then
    utils::git branch "${to}"
  else
    if [ -z "${existing_branch:-}" ]; then
      utils::git branch "${to}" ${from}
    fi
    worktree_dir=$(checkout::__create_worktree_from_ref "${to}")
    cd "${worktree_dir}" || return
    if [ "$opt" = "-B" ]; then
      utils::git checkout -B "${to}" ${from}
    else
      checkout::__trigger_post_hook
    fi
    utils::open_editor_and_store_reference
  fi
}

# Switch to a branch/tag/worktree
checkout::_switch_to_ref_and_worktree() {
  local to="${2:-}"
  local worktree_dir

  worktree_dir=$(checkout::__create_worktree_from_ref "${to}")

  if [ -d "${worktree_dir:-}" ]; then
    cd "${worktree_dir}" || return
    checkout::__trigger_post_hook
    utils::open_editor_and_store_reference
  fi
}

# Creates worktree from a given reference
checkout::__create_worktree_from_ref() {
  local to="${1}"
  local to_dir
  local bare_dir

  bare_dir=$(utils::get_bare_dir)
  to_dir=$(utils::ref_to_dir_name "${to}")

  if [ -z "$(utils::get_ref_path "${to}")" ]; then
    cd "${bare_dir}" || return
    if utils::git worktree add "${to_dir}" "${to}" --no-checkout -q; then
      echo "${bare_dir%%/}/${to_dir}"
      return
    fi
  fi

  utils::get_ref_path "${to}"
}

# Triggers post-checkout hooks
checkout::__trigger_post_hook() {
  local branch
  branch="$(utils::git branch --show-current)"
  if [[ -n "${branch}" ]]; then
    utils::git checkout -q "${branch}"
  else
    utils::git checkout -q "$(git rev-parse HEAD)"
  fi
}
