f="$HOME/.cache/dotfiles/common.sh"; [ -f "$f" ] || (mkdir -p "${f%/*}" && wget -qO "$f" https://gitea.local.vgerasimov.dev/wlad031/dotfiles/raw/branch/master/common.sh); source "$f"

source_safe "$HOME/.zshrc_host"
# source_safe "$HOME/.zshrc_user"

