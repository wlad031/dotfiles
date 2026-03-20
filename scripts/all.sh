dotfiles_tool_key() {
  local name="$1"
  local key
  key=$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]')
  key=$(printf '%s' "$key" | tr -c 'A-Z0-9' '_')
  key=${key##_}
  key=${key%%_}
  printf '%s' "$key"
}

dotfiles_set_tool_var() {
  local name="$1"
  local value="$2"
  local key
  key=$(dotfiles_tool_key "$name")
  export "DOTFILES_TOOL_${key}_INSTALLED=$value"
}

dotfiles_cmd_installed() {
  command -v "$1" >/dev/null 2>&1
}

antigen_setup() {
  local doc="https://github.com/zsh-users/antigen"
  local src="$HOME/.antigen.zsh"
  local rc="$HOME/.antigenrc"

  if [[ -f "$src" ]]; then
    source "$src"
    if [[ -f "$rc" ]]; then
      antigen init "$rc"
      if grep -q "fzf-tab" "$rc"; then
        if ! dotfiles_cmd_installed fzf; then
          log_error "Tab completion might be broken, fzf-tab is requested by $rc, but fzf is not installed"
        fi
      fi
    else
      log_error "Antigen isn't configured yet: couldn't find $rc"
    fi
  else
    log_error "Antigen isn't installed yet: couldn't find $src\n   $doc\n   Install with: curl -L git.io/antigen > .antigen.zsh"
  fi
}

ohmyposh_setup() {
  local doc="https://ohmyposh.dev/docs/installation/"
  local opt=$1
  local installed=false

  if dotfiles_cmd_installed oh-my-posh; then
    installed=true
  fi
  dotfiles_set_tool_var "ohmyposh" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "oh-my-posh is not installed\n    $doc\n   Install with: curl -s https://ohmyposh.dev/install.sh | bash -s"
    else
      log_debug "oh-my-posh is not installed\n    $doc\n   Install with: curl -s https://ohmyposh.dev/install.sh | bash -s"
    fi
    return
  fi

  if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/themes/zen.toml)"
  fi
}

git_setup() {
  local installed=false
  if dotfiles_cmd_installed git; then
    installed=true
  fi
  dotfiles_set_tool_var "git" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "Git is not installed"
    return
  fi

  git_autocommit() {
    git commit -m "[autocommit] $(date +'%Y-%m-%dT%H:%M:%S%z')"
  }

  gitac() {
    git add . && git_autocommit
  }

  gitacp() {
    gitac && git push
  }
}

eza_setup() {
  local installed=false
  if dotfiles_cmd_installed eza; then
    installed=true
  fi
  dotfiles_set_tool_var "eza" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "eza is not installed"
    return
  fi

  local eza_default_args="-la --git --git-repos-no-status --icons=auto --time-style=long-iso"
  alias ls="eza $eza_default_args"
  alias tree="eza $eza_default_args --tree"
}

bat_setup() {
  local opt=$1
  local bat_installed=false
  local batcat_installed=false

  if dotfiles_cmd_installed bat; then
    bat_installed=true
  fi
  if dotfiles_cmd_installed batcat; then
    batcat_installed=true
  fi
  dotfiles_set_tool_var "bat" "$bat_installed"
  dotfiles_set_tool_var "batcat" "$batcat_installed"

  if [[ "$bat_installed" = false && "$batcat_installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "Bat is not installed"
    else
      log_debug "Bat is not installed"
    fi
    return
  fi

  if [[ "$bat_installed" = true ]]; then
    alias cat="bat --paging=never"
    alias less="bat --paging=always"
  fi
  if [[ "$batcat_installed" = true ]]; then
    alias cat="batcat --paging=never"
    alias less="batcat --paging=always"
  fi
}

tmux_setup() {
  local installed=false
  if dotfiles_cmd_installed tmux; then
    installed=true
  fi
  dotfiles_set_tool_var "tmux" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "Tmux not installed"
    return
  fi

  export TMUX_DIR="$HOME/.tmux"
  export TMUX_PLUGINS_DIR="$TMUX_DIR/plugins"
  export TMUX_TPM_DIR="$TMUX_PLUGINS_DIR/tpm"

  alias t='tmux attach || tmux new-session'
  alias ta='tmux attach'
  alias tn='tmux new-session'
  alias tls='tmux list-sessions'

  _tmux_check_tpm
}

_tmux_check_tpm() {
  if [[ ! -d "$TMUX_TPM_DIR" ]]; then
    log_error "TPM - Tmux plugin manager is not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGINS_DIR/tpm"
    echo ""
  fi
}

cargo_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed cargo || [[ -f "$HOME/.cargo/env" ]]; then
    installed=true
  fi
  dotfiles_set_tool_var "cargo" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "cargo is not installed"
    else
      log_debug "cargo is not installed"
    fi
    return
  fi

  export CARGO_DIR="$HOME/.cargo"
  if [[ -f "$CARGO_DIR/env" ]]; then
    source_safe "$CARGO_DIR/env"
  fi
}

lima_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed limactl; then
    installed=true
  fi
  dotfiles_set_tool_var "limactl" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "lima is not installed"
    else
      log_debug "lima is not installed"
    fi
  fi

  export LIMA_DIR="$HOME/.lima"
}

colima_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed colima; then
    installed=true
  fi
  dotfiles_set_tool_var "colima" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "colima is not installed"
    else
      log_debug "colima is not installed"
    fi
  fi

  export COLIMA_DIR="$HOME/.colima"
}

rancher_setup() {
  local opt=$1
  local rancher_dir="$HOME/.rd"
  local installed=false
  if [[ -d "$rancher_dir" ]]; then
    installed=true
  fi
  dotfiles_set_tool_var "rancher" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "rancher is not installed"
    else
      log_debug "rancher is not installed"
    fi
  fi

  export PATH="$PATH:$rancher_dir/bin"
  export RANCHER_DIR="$rancher_dir"
}

docker_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed docker; then
    installed=true
  fi
  dotfiles_set_tool_var "docker" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "docker is not installed"
    else
      log_debug "docker is not installed"
    fi
    return
  fi

  __docker_set_sock() {
    local sock=$1
    if [[ ! -e "$sock" ]]; then
      log_error "Socket not found: $sock"
      return
    fi
    export DOCKER_SOCK="$sock"
    export DOCKER_HOST="unix://$sock"
    log_debug "DOCKER_HOST: $DOCKER_HOST"
  }

  __docker_change_host_lima() {
    local lima_dir="${LIMA_DIR:-$HOME/.lima}"
    __docker_set_sock "$lima_dir/${1:-default}/sock/docker.sock"
  }

  __docker_change_host_colima() {
    local colima_dir="${COLIMA_DIR:-$HOME/.colima}"
    __docker_set_sock "$colima_dir/${1:-default}/docker.sock"
  }

  __docker_change_host_rancher() {
    local rancher_dir="${RANCHER_DIR:-$HOME/.rd}"
    __docker_set_sock "$rancher_dir/docker.sock"
  }

  __docker_change_host() {
    local host=$1
    if [[ "$host" = "rancher" ]]; then
      __docker_change_host_rancher
    elif [[ "$host" = "lima" ]]; then
      __docker_change_host_lima "$2"
    elif [[ "$host" = "colima" ]]; then
      __docker_change_host_colima "$2"
    else
      log_error "Unknown docker host: $host"
    fi
  }

  __docker_better_ps() {
    command docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Image}}' "$@"  | \
      { sort -k 4; }
  }

  __docker_better_psa() {
    command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Size}}\n{{.ID}}\t{{.Image}}{{if .Ports}}{{with $p := split .Ports ", "}}\t{{len $p}} port(s) on {{end}}{{- .Networks}}{{else}}\tNo Ports on {{ .Networks }}{{end}}\n' "$@"
  }

  __docker_psnet() {
    command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Networks}}\n{{.ID}}{{if .Ports}}{{with $p := split .Ports ", "}}{{range $p}}\t\t{{println .}}{{end}}{{end}}{{else}}\t\t{{println "No Ports"}}{{end}}' "$@"
  }

  function __docker() {
    if [[ "$1" == "ps" ]]; then
      shift
      __docker_better_ps "$@"
    elif [[ "$1" == "psa" ]]; then
      shift
      __docker_better_psa "$@"
    elif [[ "$1" == "psnet" ]]; then
      shift
      __docker_psnet "$@"
    elif [[ "$1" == "host" ]]; then
      shift
      __docker_change_host "$@"
    else
      command docker "$@"
    fi
  }

  alias docker=__docker

  __docker_get_default_host() {
    if [[ -d "${RANCHER_DIR:-$HOME/.rd}" ]]; then
      echo "rancher"
    elif [[ -d "${LIMA_DIR:-$HOME/.lima}" ]]; then
      echo "lima"
    elif [[ -d "${COLIMA_DIR:-$HOME/.colima}" ]]; then
      echo "colima"
    elif [[ -f "/var/run/docker.sock" ]]; then
      echo "docker"
    fi
  }

  __docker_set_default_host() {
    local default_host=$(__docker_get_default_host)
    if [[ -z "$default_host" ]]; then
      log_debug "Could not find default docker host"
      return
    fi

    log_debug "Setting docker host to $default_host"
    __docker host "$default_host" docker
  }

  __docker_set_default_host
}

lazydocker_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed lazydocker; then
    installed=true
  fi
  dotfiles_set_tool_var "lazydocker" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "lazydocker is not installed"
    else
      log_debug "lazydocker is not installed"
    fi
  fi

  if ! dotfiles_cmd_installed docker; then
    log_error "lazydocker requires docker"
    return
  fi

  alias ldocker=lazydocker
}

fzf_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed fzf; then
    installed=true
  fi
  dotfiles_set_tool_var "fzf" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "fzf is not installed"
    else
      log_debug "fzf is not installed"
    fi
    return
  fi

  local v
  local current_version
  local required_version
  v=$(fzf --version)
  current_version=$(echo "$v" | sed 's/ (.*)//g' | sed 's/\.//g')
  required_version=$(echo "0.59.0" | sed 's/\.//g')

  if [[ "$current_version" -ge "$required_version" ]]; then
    eval "$(fzf --zsh)"
  else
    log_debug "fzf version is $v, fzf shell integration cannot be installed"
  fi

  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_DEFAULT_OPTS='--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_R_OPTS="--reverse"
  export TMUX_FZF_PREVIEW=0

  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }

  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

  if dotfiles_cmd_installed tmux; then
    export FZF_TMUX=1
    export FZF_TMUX_OPTS="-p"
  fi

  _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
      cd)           fzf --preview 'eza --tree --color=always {} | head -200'   "$@" ;;
      export|unset) fzf --preview "eval 'echo $'{}"                            "$@" ;;
      ssh)          fzf --preview 'dig {}'                                     "$@" ;;
      *)            fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
    esac
  }
}

lazygit_setup() {
  local opt=$1
  if ! dotfiles_cmd_installed git; then
    log_debug "Git is not installed"
    return
  fi

  local installed=false
  if dotfiles_cmd_installed lazygit; then
    installed=true
  fi
  dotfiles_set_tool_var "lazygit" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "lazygit is not installed"
    else
      log_debug "lazygit is not installed"
    fi
  fi

  alias lgit=lazygit
}

neovim_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed nvim; then
    installed=true
  fi
  dotfiles_set_tool_var "neovim" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "Neovim is not installed"
    else
      log_debug "Neovim is not installed"
    fi
  fi

  alias vim="nvim"
  alias v="nvim"
  export EDITOR="nvim"
}

codium_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed codium; then
    installed=true
  fi
  dotfiles_set_tool_var "codium" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "codium is not installed"
    else
      log_debug "codium is not installed"
    fi
    return
  fi

  alias code="codium"
}

fnm_setup() {
  local fnm_path="$HOME/.local/share/fnm"
  local cmd_installed=false
  local dir_installed=false
  local installed=false

  if dotfiles_cmd_installed fnm; then
    cmd_installed=true
    installed=true
  elif [[ -d "$fnm_path" ]]; then
    dir_installed=true
    installed=true
    export PATH="$fnm_path:$PATH"
  fi

  dotfiles_set_tool_var "fnm" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "fnm (Node.js version manager) is not installed"
    return
  fi

  eval "$(fnm env --use-on-cd)"
}

devmoji_setup() {
  local installed=false
  if dotfiles_cmd_installed devmoji; then
    installed=true
  fi
  dotfiles_set_tool_var "devmoji" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "Devmoji is not installed"
    return
  fi

  if dotfiles_cmd_installed git; then
    gitcoji() {
      local msg
      msg=$1
      git commit -m "$(devmoji --commit -t "$msg")"
    }
  else
    log_debug "Git is not installed"
  fi
}

flutter_setup() {
  local flutter_dir="$HOME/.flutter"
  if [[ -d "$flutter_dir" ]]; then
    export FLUTTERPATH="$flutter_dir"
    export PATH="$FLUTTERPATH/bin:$PATH"
    dotfiles_set_tool_var "flutter" true
  else
    dotfiles_set_tool_var "flutter" false
  fi
}

g_setup() {
  local installed=false
  if [[ -d "$HOME/.g" ]]; then
    installed=true
  fi
  dotfiles_set_tool_var "g" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "g is not installed"
    return
  fi

  export GOROOT="$HOME/.go"
  export GOPATH="$HOME/go"

  unalias g > /dev/null 2>&1
  source_safe "$HOME/.g/env"
}

sesh_setup() {
  local opt="${1:-optional}"
  if ! dotfiles_cmd_installed tmux; then
    log_debug_or_error $opt "sesh: tmux is not installed"
    dotfiles_set_tool_var "sesh" false
    return
  fi

  if ! dotfiles_cmd_installed sesh; then
    log_debug_or_error $opt "sesh is not installed"
    dotfiles_set_tool_var "sesh" false
    return
  fi
  dotfiles_set_tool_var "sesh" true

  function sesh-sessions() {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    [[ -z "$session" ]] && return
    sesh connect $session
  }

  zle -N sesh-sessions
  bindkey "^f" sesh-sessions
}

sdkman_setup() {
  source_safe "$HOME/.sdkman/bin/sdkman-init.sh"
  dotfiles_set_tool_var "sdkman" true
}

pyenv_setup() {
  local installed=false
  if dotfiles_cmd_installed pyenv; then
    installed=true
  fi
  dotfiles_set_tool_var "pyenv" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "pyenv (Python version manager) is not installed"
    return
  fi

  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  export PIPX_DEFAULT_PYTHON="$PYENV_ROOT/versions/3.12.2/bin/python"
}

gcloud_setup() {
  local opt=$1
  local sdk_dir="$HOME/apps/google-cloud-sdk"
  local installed=false
  if [[ -d "$sdk_dir" ]]; then
    installed=true
  fi
  dotfiles_set_tool_var "gcloud" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "Google Cloud SDK is not installed"
    else
      log_debug "Google Cloud SDK is not installed"
    fi
    return
  fi

  export GOOGLE_CLOUD_SDK_DIR="$sdk_dir"
  source_safe "$sdk_dir/path.zsh.inc"
  source_safe "$sdk_dir/completion.zsh.inc"
}

rvm_setup() {
  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
  fi

  local installed=false
  if dotfiles_cmd_installed rvm; then
    installed=true
  fi
  dotfiles_set_tool_var "rvm" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "rvm is not installed"
    return
  fi

  local rvm_dir="$HOME/.rvm"
  if [[ -d "$rvm_dir" ]]; then
    export PATH="$PATH:$rvm_dir/bin"
    if dotfiles_cmd_installed brew; then
      eval "$(brew shellenv)"
    fi
  else
    log_error "Cannot find $rvm_dir"
  fi
}

coursier_setup() {
  local installed=false
  if dotfiles_cmd_installed coursier; then
    installed=true
  fi
  dotfiles_set_tool_var "coursier" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "Coursier is not installed"
    return
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    local coursier_dir="$HOME/Library/Application Support/Coursier"
    if [[ -d "$coursier_dir" ]]; then
      export PATH="$PATH:$coursier_dir/bin"
    else
      log_error "Coursier installed in an unknown directory, not found: $coursier_dir"
    fi
  fi
}

thefuck_setup() {
  local installed=false
  if dotfiles_cmd_installed thefuck; then
    installed=true
  fi
  dotfiles_set_tool_var "thefuck" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "thefuck is not installed"
    return
  fi

  eval $(thefuck --alias)
  alias tf='fuck'
}

fastfetch_setup() {
  if [[ "$WELCOME_SCREEN_ENABLED" = false ]]; then
    return
  fi

  local installed=false
  if dotfiles_cmd_installed fastfetch; then
    installed=true
  fi
  dotfiles_set_tool_var "fastfetch" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "fastfetch is not installed"
    return
  fi

  export FASTFETCH_DIR="$HOME/.config/fastfetch"
  export FASTFETCH_CUSTOM="$FASTFETCH_DIR/custom.jsonc"
  fastfetch -c "$FASTFETCH_CUSTOM"
}

zoxide_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed zoxide; then
    installed=true
  fi
  dotfiles_set_tool_var "zoxide" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "zoxide is not installed"
    else
      log_debug "zoxide is not installed"
    fi
    return
  fi

  eval "$(zoxide init zsh)"
}

yazi_setup() {
  local installed=false
  if dotfiles_cmd_installed yazi; then
    installed=true
  fi
  dotfiles_set_tool_var "yazi" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "yazi is not installed"
    return
  fi

  function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }

  _yazi_check_flavors
}

_yazi_check_flavors() {
  local dir="$HOME/.config/yazi/flavors"
  if [[ ! -d "$dir" ]]; then
    log_error "yazi flavors directory not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone git@github.com:yazi-rs/flavors.git $dir"
    echo ""
  fi
}

_yazi_check_plugins() {
  local dir="$HOME/.config/yazi/plugins"
  if [[ ! -d "$dir" ]]; then
    log_error "yazi plugins directory not found"
    echo "Please create it like that:"
    echo ""
    echo "    mkdir $dir"
    echo ""
    return
  fi

  yarn_check_plugins_bat
}

_yazi_check_plugins_bat() {
  local dir="$HOME/.config/yazi/plugins/bat.yazi"
  if [[ ! -d "$dir" ]]; then
    log_error "yazi bat plugin not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone https://github.com/mgumz/yazi-plugin-bat.git $dir"
    echo ""
  fi
}

jetbrains_setup() {
  local installed=false
  if [[ "$OSTYPE" == "darwin"* ]]; then
    local toolbox_dir="$HOME/Library/Application Support/JetBrains/Toolbox"
    if [[ -d "$toolbox_dir" ]]; then
      installed=true
      export PATH="$toolbox_dir/scripts:$PATH"
    fi
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if dotfiles_cmd_installed jetbrains-toolbox; then
      installed=true
    fi
  else
    log_error "OSTYPE is not supported: $OSTYPE"
  fi

  dotfiles_set_tool_var "jetbrains_toolbox" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "JetBrains Toolbox is not installed"
    return
  fi
}

luaver_setup() {
  local opt=$1
  local installed=false
  if [[ -d "$HOME/.luaver" ]]; then
    installed=true
  fi
  dotfiles_set_tool_var "luaver" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "luaver (Lua version manager) is not installed"
    else
      log_debug "luaver (Lua version manager) is not installed"
    fi
    return
  fi

  source_safe "$HOME/.luaver/luaver" > /dev/null
}

sshs_setup() {
  local opt="$1"
  local installed=false
  if dotfiles_cmd_installed sshs; then
    installed=true
  fi
  dotfiles_set_tool_var "sshs" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "sshs is not installed"
    else
      log_debug "sshs is not installed"
    fi
    return
  fi
}

aerospace_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed aerospace; then
    installed=true
  fi
  dotfiles_set_tool_var "aerospace" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "aerospace is not installed"
    else
      log_debug "aerospace is not installed"
    fi
    return
  fi

  local dir="$HOME/.config/aerospace"
  if [[ ! -d "$dir" ]]; then
    log_error "Cannot find aerospace config directory: $dir"
    return
  fi

  __aerospace_change_env() {
    local gaps_file="$1"
    if [[ ! -f "$gaps_file" ]]; then
      log_error "Cannot find $gaps_file file"
      return
    fi

    local gaps
    gaps=$(cat "$gaps_file")

    local config_file="$dir/aerospace.toml"
    local template_file="$dir/aerospace-template.toml"
    if [[ ! -f "$template_file" ]]; then
      log_error "Cannot find $template_file file"
      return
    fi

    replace_placeholders "$template_file" \
       "gaps" $gaps                       \
       > "$config_file"

    log_info "Updated $config_file with:"
    echo ""
    log_info "Gaps:"
    echo "$gaps"
    echo ""

    aerospace reload-config
    log_info "Reloaded aerospace"
  }

  function __aerospace() {
    local subcommand="$1"
    if [[ "$subcommand" == "env" ]]; then
      local env="$2"
      if [[ "$env" == "work" ]]; then
        __aerospace_change_env "$dir/gaps-work.toml"
      elif [[ "$env" == "home" ]]; then
        __aerospace_change_env "$dir/gaps-home.toml"
      else
        log_error "Unknown aerospace env: $2"
      fi
    else
      command aerospace "$@"
    fi
  }

  alias aerospace=__aerospace
}

zsh_vi_setup() {
  return
}

ansible_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed ansible; then
    installed=true
  fi
  dotfiles_set_tool_var "ansible" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "ansible is not installed"
    else
      log_debug "ansible is not installed"
    fi
    return
  fi

  export ANSIBLE_DEFAULT_PRIVATE_KEY_FILE="$HOME/.ssh/homelab_cicd_rsa"

  function __vault_edit() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
      file="vault.yml"
    fi
    ansible-vault edit "$file"
  }

  function __playbook() {
    local playbook="$1"
    shift
    local args="$@"
    ansible-playbook "$playbook" --private-key="$ANSIBLE_DEFAULT_PRIVATE_KEY_FILE" "$args"
  }

  alias ave="__vault_edit"
  alias apb="__playbook"
}

tldr_setup() {
  local opt="${1:-optional}"
  local installed=false
  if dotfiles_cmd_installed tldr; then
    installed=true
  fi
  dotfiles_set_tool_var "tldr" "$installed"

  if [[ "$installed" = false ]]; then
    log_debug_or_error $opt "tldr is not installed"
    log_debug_or_error $opt "  Check: https://github.com/tealdeer-rs/tealdeer"
    return
  fi
}

tenv_setup() {
  local opt="$1"
  local installed=false
  if dotfiles_cmd_installed tenv; then
    installed=true
  fi
  dotfiles_set_tool_var "tenv" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "tenv is not installed"
    else
      log_debug "tenv is not installed"
    fi
    return
  fi
  if [[ ! -f "$HOME/.tenv.completion.zsh" ]]; then
    tenv completion zsh > $HOME/.tenv.completion.zsh
  fi
  source_safe "$HOME/.tenv.completion.zsh"
}

notes_setup() {
  export NOTES_DIR="$HOME/notes"
  export NOTES_JOURNALS_DIR="$NOTES_DIR/journals"
  export NOTES_PAGES_DIR="$NOTES_DIR/pages"
  export NOTES_TEMPLATES_DIR="$NOTES_DIR/templates"

  function __nt_open_or_create_file() {
    if [[ -f "$1" ]]; then
      $EDITOR "$1"
    else
      if [[ -n "$2" ]]; then
        local template="$2"
      fi
    fi
  }

  function __nt_journal_on_date() {
    local date="$1"
    local formatted_date
    if [[ -z "$date" ]]; then
      formatted_date=$(date +%Y_%m_%d)
    elif [[ $date == "today" || $date == "tod" ]]; then
      formatted_date=$(date +%Y_%m_%d)
    elif [[ $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      formatted_date=$(date -d "$date" +%Y_%m_%d)
    elif [[ $date =~ ^[0-9]{4}_[0-9]{2}_[0-9]{2}$ ]]; then
      formatted_date="$date"
    elif [[ $date =~ ^[0-9]{4}.[0-9]{2}.[0-9]{2}$ ]]; then
      formatted_date=$(date -d "$date" +%Y_%m_%d)
    elif [[ $date =~ "^(\+|\-)[0-9]+$" ]]; then
      formatted_date=$(date -d "$date days" +%Y_%m_%d)
    else
      log_error "Unknown date format: $date"
      return 1
    fi
    log_info "Opening journal for $formatted_date"
    $EDITOR "$NOTES_JOURNALS_DIR/$formatted_date.md"
  }

  function __nt() {
    local cmd="$1"
    shift
    if [[ -z "$cmd" ]]; then
      __nt_journal_on_date "today"
    else
      case "$cmd" in
        "journal") __nt_journal_on_date "$@";;
        *) log_error "Unknown command: $cmd"; return 1;;
      esac
    fi
  }

  alias nt="__nt"
}

occ_setup() {
  local nextcloud_container="nextcloud"
  if ! dotfiles_cmd_installed docker; then
    dotfiles_set_tool_var "occ" false
    return
  fi
  if ! docker inspect "$nextcloud_container" &>/dev/null; then
    dotfiles_set_tool_var "occ" false
    return
  fi
  dotfiles_set_tool_var "occ" true

  function __occ_command() {
    docker exec -ti -u 33 "$nextcloud_container" bash -c "./occ $@"
  }

  function __occ_scan() {
    if [[ "$1" == "all" ]]; then
      __occ_command "files:scan --all"
    else
      __occ_command "files:scan $@"
    fi
  }

  function __occ() {
      if [[ "$1" == "scan" ]]; then
        shift
        __occ_scan "$@"
      else
        __occ_command "$@"
      fi
  }

  alias occ=__occ
}

opencode_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed opencode; then
    installed=true
  fi
  dotfiles_set_tool_var "opencode" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "Opencode is not installed"
    else
      log_debug "Opencode is not installed"
    fi
    return
  fi

  local repo="git@gitea.local.vgerasimov.dev:wlad031/ai-agents.git"
  local dir="$HOME/.config/opencode/agents"

  __opencode_agents_init() {
    if [[ ! -d "$dir" ]]; then
      git clone "$repo" "$dir"
    else
      log_warn "Agents directory already exists: $dir"
    fi
  }

  __opencode_agents_pull() {
    if [[ ! -d "$dir" ]]; then
      __opencode_agents_init
    else
      cd "$dir"
      git pull
      cd -
    fi
  }

  __opencode_agents_push() {
    if [[ ! -d "$dir" ]]; then
      log_error "Agents directory does not exist: $dir"
      return 1
    else
      cd "$dir"
      gitacp
    fi
  }

  __opencode_agents() {
    if [[ "$1" == "init" ]]; then
      shift
      __opencode_agents_init
    elif [[ "$1" == "pull" ]]; then
      shift
      __opencode_agents_pull
    elif [[ "$1" == "push" ]]; then
      shift
      __opencode_agents_push
    else
      log_error "Usage: opencode agents <init|pull|push>"
    fi
  }

  function __opencode() {
    if [[ "$1" == "agents" ]]; then
      shift
      __opencode_agents "$@"
    else
      command opencode "$@"
    fi
  }

  alias opencode=__opencode
}

ask_sh_setup() {
  local opt=$1
  local installed=false
  if dotfiles_cmd_installed ask-sh; then
    installed=true
  fi
  dotfiles_set_tool_var "ask_sh" "$installed"

  if [[ "$installed" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "ask-sh is not installed"
    else
      log_debug "ask-sh is not installed"
    fi
    return
  fi
  eval "$(ask-sh --init)"
}

neofetch_setup() {
  if [[ "$WELCOME_SCREEN_ENABLED" = false ]]; then
    return
  fi

  local installed=false
  if dotfiles_cmd_installed neofetch; then
    installed=true
  fi
  dotfiles_set_tool_var "neofetch" "$installed"

  if [[ "$installed" = false ]]; then
    log_error "neofetch is not installed"
    return
  fi

  neofetch
}

sysready_status() {
  local config=""
  local scripts_dir
  local config_path
  local key var value status
  local do_load=true
  local quiet=true
  local old_log_info="$LOG_INFO_ENABLED"
  local old_log_warn="$LOG_WARN_ENABLED"
  local old_log_error="$LOG_ERROR_ENABLED"
  local old_log_debug="$LOG_DEBUG_ENABLED"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --config)
        shift
        config="${1:-}"
        shift
        ;;
      --no-load)
        do_load=false
        shift
        ;;
      --verbose)
        quiet=false
        shift
        ;;
      -h|--help)
        echo "Usage: sysready_status [--config path] [--no-load] [--verbose]"
        return 0
        ;;
      *)
        echo "error: unknown argument: $1" >&2
        return 2
        ;;
    esac
  done

  scripts_dir="${DOTFILES_SCRIPTS_DIR:-$HOME/dotfiles/scripts}"
  config_path="${config:-${DOTFILES_SYSREADY_CONFIG:-$scripts_dir/../sysready.yaml}}"

  if [[ ! -f "$config_path" ]]; then
    echo "error: config not found: $config_path" >&2
    return 2
  fi

  if ! dotfiles_cmd_installed yq; then
    echo "error: yq not found" >&2
    return 2
  fi

  if [[ "$quiet" = true ]]; then
    LOG_INFO_ENABLED=false
    LOG_WARN_ENABLED=false
    LOG_ERROR_ENABLED=false
    LOG_DEBUG_ENABLED=false
  fi

  if ! typeset -f dotfiles_module_load_all >/dev/null 2>&1; then
    if [[ -f "$scripts_dir/module_loader.sh" ]]; then
      # shellcheck disable=SC1090
      source "$scripts_dir/module_loader.sh"
    fi
  fi

  if [[ "$do_load" = true ]]; then
    if typeset -f dotfiles_module_load_all >/dev/null 2>&1; then
      dotfiles_module_load_all "$config_path"
    fi
  fi

  while IFS= read -r name; do
    [[ -z "$name" ]] && continue
    key=$(dotfiles_tool_key "$name")
    var="DOTFILES_TOOL_${key}_INSTALLED"
    value=$(eval "printf '%s' \"\${$var-}\"")
    if [[ -z "$value" ]]; then
      value="unknown"
    fi
    if [[ "$value" == "true" || "$value" == "1" ]]; then
      status="OK"
    else
      status="FAIL"
    fi
    printf '%-30s %s\n' "$name" "$status"
  done < <(
    yq -r '.tools[] | select(.load) | .name // ""' "$config_path" 2>/dev/null
  )

  LOG_INFO_ENABLED="$old_log_info"
  LOG_WARN_ENABLED="$old_log_warn"
  LOG_ERROR_ENABLED="$old_log_error"
  LOG_DEBUG_ENABLED="$old_log_debug"
}
