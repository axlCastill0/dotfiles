#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

# Toolchain check. --deps lets it install what is missing; without the flag it
# only reports and stops, so this stays a symlink script by default.
deps_args=()
for arg in "$@"; do
  case "$arg" in
    --deps) deps_args=(--install) ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done
./scripts/deps.sh "${deps_args[@]+"${deps_args[@]}"}"

common=(nvim zsh ghostty)
linux=(i3)
#macos=(aerospace karabiner)

case "$(uname -s)" in
  Linux)  packages=("${common[@]}" "${linux[@]}") ;;
  Darwin) packages=("${common[@]}") ;;
  *)      echo "unsupported platform: $(uname -s)" >&2; exit 1 ;;
esac

# per-host extras
#case "$(hostname -s)" in
#  work-laptop) packages+=(work-git) ;;
#  desktop)     packages+=(multimonitor) ;;
#esac

mkdir -p ~/.config
stow -R --no-folding "${packages[@]}"
