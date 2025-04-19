if ! command -v git &> /dev/null; then
  echo "git not found"
  exit 1
fi

git clone git@gitea.local.vgerasimov.dev:wlad031/dotfiles.git ~/dotfiles

