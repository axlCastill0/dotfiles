#!/usr/bin/env bash
# Checks for the toolchain the Neovim config needs but cannot install itself.
#
#   node      mason LSP servers are npm packages (vtsls, eslint, pyright,
#             prismals, tailwindcss)
#   luarocks  lazy.nvim builds plugins that ship a rockspec; oxocarbon.nvim
#             does, and fails to load without it
#   stow      install.sh itself
#   git       lazy.nvim bootstrap, gitsigns
#   cc        treesitter parser compilation
#
# Default is report-only. Pass --install to let the system package manager
# install whatever is missing.
set -euo pipefail

install=0
[ "${1-}" = "--install" ] && install=1

have() { command -v "$1" >/dev/null 2>&1; }

# tool -> brew / apt / pacman / dnf package name
pkg_for() {
  local mgr=$1 tool=$2
  case "$tool" in
    node)
      case "$mgr" in
        brew) echo node ;;
        apt) echo nodejs ;;
        *) echo nodejs ;;
      esac ;;
    luarocks) echo luarocks ;;
    stow)
      case "$mgr" in
        apt) echo stow ;;
        *) echo stow ;;
      esac ;;
    git) echo git ;;
    cc)
      case "$mgr" in
        brew) echo "" ;;            # Xcode CLT, handled separately
        apt) echo build-essential ;;
        pacman) echo base-devel ;;
        dnf) echo gcc ;;
      esac ;;
  esac
}

detect_mgr() {
  if [ "$(uname -s)" = "Darwin" ]; then
    have brew && { echo brew; return; }
  fi
  for m in apt pacman dnf; do
    have "$m" && { echo "$m"; return; }
  done
  echo ""
}

install_cmd() {
  case "$1" in
    brew)   echo "brew install" ;;
    apt)    echo "sudo apt install -y" ;;
    pacman) echo "sudo pacman -S --needed --noconfirm" ;;
    dnf)    echo "sudo dnf install -y" ;;
  esac
}

tools=(git stow node luarocks)
missing=()

for t in "${tools[@]}"; do
  have "$t" || missing+=("$t")
done

# any C compiler satisfies treesitter
if ! have cc && ! have gcc && ! have clang; then
  missing+=(cc)
fi

if [ ${#missing[@]} -eq 0 ]; then
  echo "deps: all present (${tools[*]}, C compiler)"
  exit 0
fi

mgr=$(detect_mgr)

if [ -z "$mgr" ]; then
  echo "deps: missing: ${missing[*]}" >&2
  if [ "$(uname -s)" = "Darwin" ]; then
    echo "deps: no homebrew found. Install it from https://brew.sh then re-run." >&2
  else
    echo "deps: no supported package manager (apt/pacman/dnf). Install the above manually." >&2
  fi
  exit 1
fi

cmd=$(install_cmd "$mgr")

pkgs=()
need_clt=0
for t in "${missing[@]}"; do
  p=$(pkg_for "$mgr" "$t")
  if [ -z "$p" ]; then
    [ "$t" = cc ] && need_clt=1
    continue
  fi
  pkgs+=("$p")
done

if [ "$install" -eq 0 ]; then
  echo "deps: missing: ${missing[*]}" >&2
  [ ${#pkgs[@]} -gt 0 ] && echo "deps: install with: $cmd ${pkgs[*]}" >&2
  [ "$need_clt" -eq 1 ] && echo "deps: install a C compiler with: xcode-select --install" >&2
  echo "deps: or re-run ./install.sh --deps to do it automatically" >&2
  exit 1
fi

if [ ${#pkgs[@]} -gt 0 ]; then
  echo "deps: installing ${pkgs[*]} via $mgr"
  $cmd "${pkgs[@]}"
fi

if [ "$need_clt" -eq 1 ]; then
  echo "deps: installing Xcode command line tools"
  xcode-select --install || true
fi

echo "deps: done"
