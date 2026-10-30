#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

common=(nvim git zsh ghostty)
linux=(i3)
#macos=(aerospace karabiner)

case "$(uname -s)" in
  Linux)  packages=("${common[@]}" "${linux[@]}") ;;
#  Darwin) packages=("${common[@]}" "${macos[@]}") ;;
esac

# per-host extras
#case "$(hostname -s)" in
#  work-laptop) packages+=(work-git) ;;
#  desktop)     packages+=(multimonitor) ;;
#esac

mkdir -p ~/.config
stow -R --no-folding "${packages[@]}"

