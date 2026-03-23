x="bash/lib/common.sh"; f="$HOME/dotfiles/$x"; [ -f $f ] || f="$HOME/.cache/dotfiles/$x" && [ -f $f ] || (mkdir -p ${f%/*} && wget -qO $f "https://raw.githubusercontent.com/wlad031/dotfiles/refs/heads/master/$x"); source $f

###############################################################################
# Common aliases
alias xx='exit'
alias zz='exit'
alias ll="ls -la"
# be paranoid
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'
###############################################################################

__tool_key() {
  local name="$1"
  local key
  key=$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]')
  key=$(printf '%s' "$key" | tr -c 'A-Z0-9' '_')
  key=${key##_}
  key=${key%%_}
  printf '%s' "$key"
}

__module_key() {
  local name="$1"
  local key
  key=$(printf '%s' "$name" | tr '[:lower:]' '[:upper:]')
  key=$(printf '%s' "$key" | tr -c 'A-Z0-9' '_')
  key=${key##_}
  key=${key%%_}
  printf '%s' "$key"
}

__module_export() {
  local name="$1"
  local module_status="$2"
  local prefix="${DOTFILES_MODULE_PREFIX:-DOTFILES_MODULE_}"
  local key
  key=$(__module_key "$name")
  export "${prefix}${key}=${module_status}"
}

__module_load() {
  local name="$1"
  local setup_fn="${2:-}"

  if [[ -n "$setup_fn" ]] && typeset -f "$setup_fn" >/dev/null 2>&1; then
    __module_export "$name" 1
    "$setup_fn"
  else
    __module_export "$name" 0
  fi
}

__module_iter() {
  local config="$1"

  if [[ -z "$config" || ! -f "$config" ]]; then
    return 0
  fi

  if ! command -v yq >/dev/null 2>&1; then
    return 0
  fi

  yq -r '.tools // {} | to_entries | map(select(.value.load != null and .value.load != false)) | .[] | . as $item | ($item.value.load // true) as $load | [$item.key, (if ($load | type) == "object" then ($load.setup // ($item.key + "_setup")) else ($item.key + "_setup") end)] | @tsv' "$config"
}

__module_iter_merged() {
  local -a configs=("$@")
  local merged_config

  if [[ ${#configs[@]} -eq 0 ]]; then
    return 0
  fi

  if ! command -v yq >/dev/null 2>&1; then
    return 0
  fi

  merged_config=$(mktemp)
  if yq eval-all 'reduce .[] as $item ({}; . * $item)' "${configs[@]}" >"$merged_config" 2>/dev/null; then
    __module_iter "$merged_config"
    rm -f "$merged_config"
    return 0
  fi
  if yq -y -s 'reduce .[] as $item ({}; . * $item)' "${configs[@]}" >"$merged_config" 2>/dev/null; then
    __module_iter "$merged_config"
    rm -f "$merged_config"
    return 0
  fi
  rm -f "$merged_config"
  return 0
}

dotfiles_module_load_all() {
  local default_config="$HOME/tools.yaml"
  local default_host_config="$HOME/tools.host.yaml"
  local -a config_paths
  local -a module_entries
  local entry name setup
  local first_config

  if [[ $# -gt 0 ]]; then
    config_paths=("$@")
  elif [[ -n "${DOTFILES_SYSREADY_CONFIG:-}" ]]; then
    config_paths=(${=DOTFILES_SYSREADY_CONFIG})
  else
    config_paths=("$default_config" "$default_host_config")
  fi

  if [[ ${#config_paths[@]} -gt 0 ]]; then
    local -a filtered_paths=()
    for config in "${config_paths[@]}"; do
      [[ -z "$config" ]] && continue
      filtered_paths+=("$config")
    done
    config_paths=("${filtered_paths[@]}")
  fi

  for config in "${config_paths[@]}"; do
    if [[ ! -f "$config" ]]; then
      return 0
    fi
  done

  if [[ ${#config_paths[@]} -eq 0 ]]; then
    return 0
  fi

  first_config="${config_paths[0]:-${config_paths[1]-}}"
  if [[ -z "$first_config" ]]; then
    return 0
  fi

  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    module_entries+=("$entry")
  done < <(__module_iter "$first_config")

  if [[ ${#config_paths[@]} -gt 1 ]]; then
    module_entries=()
    while IFS= read -r entry; do
      [[ -z "$entry" ]] && continue
      module_entries+=("$entry")
    done < <(__module_iter_merged "${config_paths[@]}")
  fi

  for entry in "${module_entries[@]}"; do
    IFS=$'\t' read -r name setup <<< "$entry"
    [[ -z "$name" ]] && continue
    __module_load "$name" "$setup"
  done
}

__set_tool_var() {
  local name="$1"
  local value="$2"
  local key
  key=$(__tool_key "$name")
  export "DOTFILES_TOOL_${key}_INSTALLED=$value"
}

__cmd_installed() {
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
        if ! __cmd_installed fzf; then
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
  local installed=false

  if __cmd_installed oh-my-posh; then
    installed=true
  fi
  __set_tool_var "ohmyposh" "$installed"

  if [[ "$installed" = true ]]; then
    if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
      eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/themes/zen.toml)"
    fi
  fi
}

git_setup() {
  local installed=false
  if __cmd_installed git; then
    installed=true
  fi
  __set_tool_var "git" "$installed"

  if [[ "$installed" = true ]]; then
    __git_autocommit() {
      git commit -m "[autocommit] $(date +'%Y-%m-%dT%H:%M:%S%z')"
    }

    gitac() {
      git add . && __git_autocommit
    }

    gitacp() {
      gitac && git push
    }
  fi
}

eza_setup() {
  local installed=false
  if __cmd_installed eza; then
    installed=true
  fi
  __set_tool_var "eza" "$installed"

  if [[ "$installed" = true ]]; then
    local eza_default_args="-la --git --git-repos-no-status --icons=auto --time-style=long-iso"
    alias ls="eza $eza_default_args"
    alias tree="eza $eza_default_args --tree"
  fi
}

bat_setup() {
  local bat_installed=false
  local batcat_installed=false

  if __cmd_installed bat; then
    bat_installed=true
  fi
  if __cmd_installed batcat; then
    batcat_installed=true
  fi
  __set_tool_var "bat" "$bat_installed"
  __set_tool_var "batcat" "$batcat_installed"

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
  if __cmd_installed tmux; then
    installed=true
  fi
  __set_tool_var "tmux" "$installed"

  export TMUX_DIR="$HOME/.tmux"
  export TMUX_PLUGINS_DIR="$TMUX_DIR/plugins"
  export TMUX_TPM_DIR="$TMUX_PLUGINS_DIR/tpm"

  alias t='tmux attach || tmux new-session'
  alias ta='tmux attach'
  alias tn='tmux new-session'
  alias tls='tmux list-sessions'

  __tmux_check_tpm
}

__tmux_check_tpm() {
  if [[ ! -d "$TMUX_TPM_DIR" ]]; then
    log_error "TPM - Tmux plugin manager is not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone https://github.com/tmux-plugins/tpm $TMUX_PLUGINS_DIR/tpm"
    echo ""
  fi
}

cargo_setup() {
  local installed=false
  if __cmd_installed cargo || [[ -f "$HOME/.cargo/env" ]]; then
    installed=true
  fi
  __set_tool_var "cargo" "$installed"

  if [[ "$installed" = true ]]; then
    export CARGO_DIR="$HOME/.cargo"
    if [[ -f "$CARGO_DIR/env" ]]; then
      source_safe "$CARGO_DIR/env"
    fi
  fi
}

lima_setup() {
  local installed=false
  if __cmd_installed limactl; then
    installed=true
  fi
  __set_tool_var "limactl" "$installed"

  if [[ "$installed" = true ]]; then
    export LIMA_DIR="$HOME/.lima"
  fi
}

colima_setup() {
  local installed=false
  if __cmd_installed colima; then
    installed=true
  fi
  __set_tool_var "colima" "$installed"

  if [[ "$installed" = true ]]; then
    export COLIMA_DIR="$HOME/.colima"
  fi
}

rancher_setup() {
  local rancher_dir="$HOME/.rd"
  local installed=false
  if [[ -d "$rancher_dir" ]]; then
    installed=true
  fi
  __set_tool_var "rancher" "$installed"

  if [[installed = true ]]; then
    export PATH="$PATH:$rancher_dir/bin"
    export RANCHER_DIR="$rancher_dir"
  fi
}

docker_setup() {
  local installed=false
  if __cmd_installed docker; then
    installed=true
  fi
  __set_tool_var "docker" "$installed"

  if [[ "$installed" = true ]]; then
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
  fi
}

lazydocker_setup() {
  local installed=false
  if __cmd_installed lazydocker; then
    installed=true
  fi
  __set_tool_var "lazydocker" "$installed"

  if ! __cmd_installed docker; then
    log_error "lazydocker requires docker"
    return
  fi

  if [[ "$installed" = true ]]; then
    alias ldocker=lazydocker
  fi
}

fzf_setup() {
  local installed=false
  if __cmd_installed fzf; then
    installed=true
  fi
  __set_tool_var "fzf" "$installed"

  if [[ "$installed" = true ]]; then
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

    if __cmd_installed tmux; then
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
  fi
}

lazygit_setup() {
  if ! __cmd_installed git; then
    log_debug "Git is not installed"
    return
  fi

  local installed=false
  if __cmd_installed lazygit; then
    installed=true
  fi
  __set_tool_var "lazygit" "$installed"

  if [[ "$installed" = true ]]; then
    alias lgit=lazygit
  fi
}

neovim_setup() {
  local installed=false
  if __cmd_installed nvim; then
    installed=true
  fi
  __set_tool_var "neovim" "$installed"

  if [[ "$installed" = true ]]; then
    alias vim="nvim"
    alias v="nvim"
    export EDITOR="nvim"
  fi
}

codium_setup() {
  local installed=false
  if __cmd_installed codium; then
    installed=true
  fi
  __set_tool_var "codium" "$installed"

  if [[ "$installed" = true ]]; then
    alias code="codium"
  fi
}

fnm_setup() {
  local fnm_path="$HOME/.local/share/fnm"
  local cmd_installed=false
  local dir_installed=false
  local installed=false

  if __cmd_installed fnm; then
    cmd_installed=true
    installed=true
  elif [[ -d "$fnm_path" ]]; then
    dir_installed=true
    installed=true
    export PATH="$fnm_path:$PATH"
  fi

  __set_tool_var "fnm" "$installed"

  if [[ "$installed" = true ]]; then
    eval "$(fnm env --use-on-cd)"
  fi
}

devmoji_setup() {
  local installed=false
  if __cmd_installed devmoji; then
    installed=true
  fi
  __set_tool_var "devmoji" "$installed"

  if [[ "$installed" = true ]]; then
    if __cmd_installed git; then
      gitcoji() {
        local msg
        msg=$1
        git commit -m "$(devmoji --commit -t "$msg")"
      }
    else
      log_debug "Git is not installed"
    fi
  fi
}

flutter_setup() {
  local flutter_dir="$HOME/.flutter"
  if [[ -d "$flutter_dir" ]]; then
    export FLUTTERPATH="$flutter_dir"
    export PATH="$FLUTTERPATH/bin:$PATH"
    __set_tool_var "flutter" true
  else
    __set_tool_var "flutter" false
  fi
}

g_setup() {
  local installed=false
  if [[ -d "$HOME/.g" ]]; then
    installed=true
  fi
  __set_tool_var "g" "$installed"

  if [[ "$installed" = true ]]; then
    export GOROOT="$HOME/.go"
    export GOPATH="$HOME/go"

    unalias g > /dev/null 2>&1
    source_safe "$HOME/.g/env"
  fi
}

sesh_setup() {

  __set_tool_var "sesh" true

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
  __set_tool_var "sdkman" true
}

pyenv_setup() {
  local installed=false
  if __cmd_installed pyenv; then
    installed=true
  fi
  __set_tool_var "pyenv" "$installed"

  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  export PIPX_DEFAULT_PYTHON="$PYENV_ROOT/versions/3.12.2/bin/python"
}

gcloud_setup() {
  local sdk_dir="$HOME/apps/google-cloud-sdk"
  local installed=false
  if [[ -d "$sdk_dir" ]]; then
    installed=true
  fi
  __set_tool_var "gcloud" "$installed"

  if [[ "$installed" = true ]]; then
    export GOOGLE_CLOUD_SDK_DIR="$sdk_dir"
    source_safe "$sdk_dir/path.zsh.inc"
    source_safe "$sdk_dir/completion.zsh.inc"
  fi
}

rvm_setup() {
  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
  fi

  local installed=false
  if __cmd_installed rvm; then
    installed=true
  fi
  __set_tool_var "rvm" "$installed"

  local rvm_dir="$HOME/.rvm"
  if [[ -d "$rvm_dir" ]]; then
    export PATH="$PATH:$rvm_dir/bin"
    if __cmd_installed brew; then
      eval "$(brew shellenv)"
    fi
  else
    log_error "Cannot find $rvm_dir"
  fi
}

coursier_setup() {
  local installed=false
  if __cmd_installed coursier; then
    installed=true
  fi
  __set_tool_var "coursier" "$installed"

  if [[ "$installed" = true ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      local coursier_dir="$HOME/Library/Application Support/Coursier"
      if [[ -d "$coursier_dir" ]]; then
        export PATH="$PATH:$coursier_dir/bin"
      else
        log_error "Coursier installed in an unknown directory, not found: $coursier_dir"
      fi
    fi
  fi
}

thefuck_setup() {
  local installed=false
  if __cmd_installed thefuck; then
    installed=true
  fi
  __set_tool_var "thefuck" "$installed"

  eval $(thefuck --alias)
  if [[ "$installed" = true ]]; then
    alias tf='fuck'
  fi
}

fastfetch_setup() {
  if [[ "$WELCOME_SCREEN_ENABLED" = false ]]; then
    return
  fi

  local installed=false
  if __cmd_installed fastfetch; then
    installed=true
  fi
  __set_tool_var "fastfetch" "$installed"

  if [[ "$installed" = true ]]; then
    export FASTFETCH_DIR="$HOME/.config/fastfetch"
    export FASTFETCH_CUSTOM="$FASTFETCH_DIR/custom.jsonc"
    fastfetch -c "$FASTFETCH_CUSTOM"
  fi
}

zoxide_setup() {
  local installed=false
  if __cmd_installed zoxide; then
    installed=true
  fi
  __set_tool_var "zoxide" "$installed"

  if [[ "$installed" = true ]]; then
    eval "$(zoxide init zsh)"
  fi
}

yazi_setup() {
  local installed=false
  if __cmd_installed yazi; then
    installed=true
  fi
  __set_tool_var "yazi" "$installed"

  if [[ "$installed" = true ]]; then
    function yy() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }

    __yazi_check_flavors
  fi
}

__yazi_check_flavors() {
  local dir="$HOME/.config/yazi/flavors"
  if [[ ! -d "$dir" ]]; then
    log_error "yazi flavors directory not found"
    echo "Please install it like that:"
    echo ""
    echo "    git clone git@github.com:yazi-rs/flavors.git $dir"
    echo ""
  fi
}

__yazi_check_plugins() {
  local dir="$HOME/.config/yazi/plugins"
  if [[ ! -d "$dir" ]]; then
    log_error "yazi plugins directory not found"
    echo "Please create it like that:"
    echo ""
    echo "    mkdir $dir"
    echo ""
    return
  fi

  __yazi_check_plugins_bat
}

__yazi_check_plugins_bat() {
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
    if __cmd_installed jetbrains-toolbox; then
      installed=true
    fi
  else
    log_error "OSTYPE is not supported: $OSTYPE"
  fi

  __set_tool_var "jetbrains_toolbox" "$installed"
}

luaver_setup() {
  local installed=false
  if [[ -d "$HOME/.luaver" ]]; then
    installed=true
  fi
  __set_tool_var "luaver" "$installed"

  if [[ "$installed" = true ]]; then
    source_safe "$HOME/.luaver/luaver" > /dev/null
  fi
}

sshs_setup() {
  local installed=false
  if __cmd_installed sshs; then
    installed=true
  fi
  __set_tool_var "sshs" "$installed"
}

aerospace_setup() {
  local installed=false
  if __cmd_installed aerospace; then
    installed=true
  fi
  __set_tool_var "aerospace" "$installed"

  if [[ "$installed" = true ]]; then
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
  fi
}

zsh_vi_setup() {
  return
}

ansible_setup() {
  local installed=false
  if __cmd_installed ansible; then
    installed=true
  fi
  __set_tool_var "ansible" "$installed"

  if [[ "$installed" = true ]]; then
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
  fi
}

tldr_setup() {
  local installed=false
  if __cmd_installed tldr; then
    installed=true
  fi
  __set_tool_var "tldr" "$installed"
}

tenv_setup() {
  local installed=false
  if __cmd_installed tenv; then
    installed=true
  fi
  __set_tool_var "tenv" "$installed"

  if [[ "$installed" = true ]]; then
    if [[ ! -f "$HOME/.tenv.completion.zsh" ]]; then
      tenv completion zsh > $HOME/.tenv.completion.zsh
    fi
    source_safe "$HOME/.tenv.completion.zsh"
  fi
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
  if ! __cmd_installed docker; then
    __set_tool_var "occ" false
    return
  fi
  if ! docker inspect "$nextcloud_container" &>/dev/null; then
    __set_tool_var "occ" false
    return
  fi
  __set_tool_var "occ" true

  if [[ "$installed" = true ]]; then
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
  fi
}

opencode_setup() {
  local installed=false
  if __cmd_installed opencode; then
    installed=true
  fi
  __set_tool_var "opencode" "$installed"

  __opencode_agents_repo="git@gitea.local.vgerasimov.dev:wlad031/ai-agents.git"
  __opencode_agents_dir="$HOME/.config/opencode/agents"

  if [[ "$installed" = true ]]; then

    __opencode_agents_init() {
      if [[ ! -d "$__opencode_agents_dir" ]]; then
        git clone "$__opencode_agents_repo" "$__opencode_agents_dir"
      else
        log_warn "Agents directory already exists: $__opencode_agents_dir"
      fi
    }

    __opencode_agents_pull() {
      if [[ ! -d "$__opencode_agents_dir" ]]; then
        __opencode_agents_init
      else
        cd "$__opencode_agents_dir"
        git pull
        cd -
      fi
    }

    __opencode_agents_push() {
      if [[ ! -d "$__opencode_agents_dir" ]]; then
        log_error "Agents directory does not exist: $__opencode_agents_dir"
        return 1
      else
        cd "$__opencode_agents_dir"
        gitacp
        cd -
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
  fi
}

ask_sh_setup() {
  local installed=false
  if __cmd_installed ask-sh; then
    installed=true
  fi
  __set_tool_var "ask_sh" "$installed"

  if [[ "$installed" = true ]]; then
    eval "$(ask-sh --init)"
  fi
}

neofetch_setup() {
  if [[ "$WELCOME_SCREEN_ENABLED" = false ]]; then
    return
  fi

  local installed=false
  if __cmd_installed neofetch; then
    installed=true
  fi
  __set_tool_var "neofetch" "$installed"

  if [[ "$installed" = true ]]; then
    neofetch
  fi
}

sysready_status() {
  local -a config_paths
  local default_config
  local default_host_config
  local first_config
  local key var value tool_status
  local quiet=true
  local explicit_config=false
  local old_log_info="$LOG_INFO_ENABLED"
  local old_log_warn="$LOG_WARN_ENABLED"
  local old_log_error="$LOG_ERROR_ENABLED"
  local old_log_debug="$LOG_DEBUG_ENABLED"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --config)
        shift
        if [[ -n "${1:-}" ]]; then
          config_paths+=("$1")
          explicit_config=true
        fi
        shift
        ;;
      --verbose)
        quiet=false
        shift
        ;;
      -h|--help)
        echo "Usage: sysready_status [--config path] [--verbose]"
        return 0
        ;;
      *)
        echo "error: unknown argument: $1" >&2
        return 2
        ;;
    esac
  done

  default_config="$HOME/tools.yaml"
  default_host_config="$HOME/tools.host.yaml"
  if [[ ${#config_paths[@]} -eq 0 ]]; then
    if [[ -n "${DOTFILES_SYSREADY_CONFIG:-}" ]]; then
      config_paths=(${=DOTFILES_SYSREADY_CONFIG})
    else
      config_paths=("$default_config" "$default_host_config")
    fi
  fi

  if [[ ${#config_paths[@]} -gt 0 ]]; then
    local -a filtered_paths=()
    for config in "${config_paths[@]}"; do
      [[ -z "$config" ]] && continue
      filtered_paths+=("$config")
    done
    config_paths=("${filtered_paths[@]}")
  fi

  if [[ ${#config_paths[@]} -eq 0 ]]; then
    if [[ "$explicit_config" = true ]]; then
      echo "error: config not found" >&2
      return 2
    fi
    log_warn "No sysready config found"
    return 0
  fi

  first_config="${config_paths[0]:-${config_paths[1]-}}"
  if [[ -z "$first_config" ]]; then
    echo "error: config not found" >&2
    return 2
  fi

  if [[ "$quiet" = true ]]; then
    LOG_INFO_ENABLED=false
    LOG_WARN_ENABLED=false
    LOG_ERROR_ENABLED=false
    LOG_DEBUG_ENABLED=false
  fi

  while IFS=$'\t' read -r name setup; do
    [[ -z "$name" ]] && continue
    key=$(__tool_key "$name")
    var="DOTFILES_TOOL_${key}_INSTALLED"
    value=$(eval "printf '%s' \"\${$var-}\"")
    if [[ -z "$value" ]]; then
      value="unknown"
    fi
    if [[ "$value" == "true" || "$value" == "1" ]]; then
      tool_status="OK"
    else
      tool_status="FAIL"
    fi
    printf '%-30s %s\n' "$name" "$tool_status"
  done < <(__module_iter "$first_config")

  if [[ ${#config_paths[@]} -gt 1 ]]; then
    while IFS=$'\t' read -r name setup; do
      [[ -z "$name" ]] && continue
      key=$(__tool_key "$name")
      var="DOTFILES_TOOL_${key}_INSTALLED"
      value=$(eval "printf '%s' \"\${$var-}\"")
      if [[ -z "$value" ]]; then
        value="unknown"
      fi
      if [[ "$value" == "true" || "$value" == "1" ]]; then
        tool_status="OK"
      else
        tool_status="FAIL"
      fi
      printf '%-30s %s\n' "$name" "$tool_status"
    done < <(__module_iter_merged "${config_paths[@]}")
  fi

  LOG_INFO_ENABLED="$old_log_info"
  LOG_WARN_ENABLED="$old_log_warn"
  LOG_ERROR_ENABLED="$old_log_error"
  LOG_DEBUG_ENABLED="$old_log_debug"
}

source_safe "$HOME/.zshrc_host"
# source_safe "$HOME/.zshrc_user"
dotfiles_module_load_all
