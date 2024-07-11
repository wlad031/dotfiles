if ! command -v git &> /dev/null; then
  export GIT_INSTALLED=false
else
  export GIT_INSTALLED=true
fi

git_setup() {
  if [[ "$GIT_INSTALLED" = false ]]; then
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
