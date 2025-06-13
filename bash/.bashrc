x="bash/lib/logging.sh"; f="$HOME/dotfiles/$x"; [ -f $f ] || f="$HOME/.cache/dotfiles/$x" && [ -f $f ] || (mkdir -p ${f%/*} && wget -qO $f "https://raw.githubusercontent.com/wlad031/dotfiles/refs/heads/master/$x"); source $f
log_info "Are you sure you want pure Bash?\nInstall ZSH: https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH"
