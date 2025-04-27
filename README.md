# dotfiles

## Checklist for initial setup
- [ ] install `uv` for Python
  ```bash
    wget -q -O - https://raw.githubusercontent.com/wlad031/dotfiles/refs/heads/master/install-uv.sh | bash
  ```
- [ ] install Ansible
  ```bash
    wget -q -O - https://raw.githubusercontent.com/wlad031/dotfiles/refs/heads/master/install-ansible.sh | bash
  ```
- [ ] install Bitwarden
  - [ ] setup Bitwarden as SSH agent
- [ ] install `rvm` for Ruby
- [ ] install homebrew
- [ ] install essential packages
- [ ] install sdkman
- [ ] install Go with `g`
- [ ] install dotfiles
  ```bash
  bash install-dotfiles.sh --tags <comma-separated-tags>
  ```
- [ ] Gruvbox wallpapers
  ```bash
  mkdir -p ~/Pictures/wallpapers
  ```
  ```bash
  git clone git@gitea.local.vgerasimov.dev:public-archive/gruvbox-wallpapers.git ~/Pictures/wallpapers/gruvbox-wallpapers
  ```

