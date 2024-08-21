GOOGLE_CLOUD_SDK_DIR="$HOME/apps/google-cloud-sdk"

if [[ -d "$GOOGLE_CLOUD_SDK_DIR" ]]; then
  export GOOGLE_CLOUD_SDK_INSTALLED=true
else
  export GOOGLE_CLOUD_SDK_INSTALLED=false
fi

gcloud_setup() {
  local opt=$1
  if [[ "$GOOGLE_CLOUD_SDK_INSTALLED" = false ]]; then
    if [[ "$opt" = "required" ]]; then
      log_error "Google Cloud SDK is not installed"
    else
      log_debug "Google Cloud SDK is not installed"
    fi
    return
  fi

  export GOOGLE_CLOUD_SDK_DIR
  source_safe "$HOME/apps/google-cloud-sdk/path.zsh.inc"
  source_safe "$HOME/apps/google-cloud-sdk/completion.zsh.inc"
}
