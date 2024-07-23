flutter_setup() {
  FLUTTER_DIR="$HOME/.flutter"
  if [[ -d "$FLUTTER_DIR" ]]; then
    export FLUTTERPATH="$FLUTTER_DIR"
    export PATH="$FLUTTERPATH/bin:$PATH"
  fi
}
