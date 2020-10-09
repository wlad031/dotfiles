#zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -f "$HOME/.sh-alias.sh" ]; then source "$HOME/.sh-alias.sh"; fi

export EDITOR='vim'
export LC_ALL=en_US.UTF-8

# TODO: correct working with python and pyenv
export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"

export EMACSD_DIR="$HOME/.emacs.d/"

# TODO: use simplified syntax
if [ -f "$HOME/.load_sdkman.sh" ]; then source "$HOME/.load_sdkman.sh"; fi
if [ -f "$HOME/.load_gcsdk.sh" ]; then source "$HOME/.load_gcsdk.sh"; fi
if [ -f "$HOME/.load_nvm.sh" ]; then source "$HOME/.load_nvm.sh"; fi
if [ -f "$HOME/.load_pyenv.sh" ]; then source "$HOME/.load_pyenv.sh"; fi
if [ -f "$HOME/.load_go.sh" ]; then source "$HOME/.load_go.sh"; fi
if [ -f "$HOME/.load_ignite.sh" ]; then source "$HOME/.load_ignite.sh"; fi

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.jetbrains:$PATH"

# TODO: do I really need this?
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# TODO: segragate antigen using into specific file
source ~/.antigen.zsh

antigen use oh-my-zsh

antigen bundle git
#antigen bundle heroku
antigen bundle pip
antigen bundle lein
#antigen bundle command-not-found
antigen bundle docker
antigen bundle 'wfxr/forgit'
antigen bundle kazhala/dotbare

antigen bundle zsh-users/zsh-syntax-highlighting

antigen bundle web-search

#antigen theme robbyrussell
antigen theme romkatv/powerlevel10k

antigen apply

bkp() {
    FILE=$1
    BKP="$FILE.bkp"
    echo "Backup file $FILE to $BKP"
    cp $FILE $BKP
}

sso() {
ROLE=""
AWS_PROFILE=saml
AWS_REGION="us-east-1"
IDP_ACCOUNT=default
case $1 in
merkle-esgops)
    ROLE="arn:aws:iam::313508329247:role/MerkleWebSSOAdmins"
    AWS_PROFILE=merkle-esgops
    IDP_ACCOUNT="merkle-esgops"
    ;;
merkle-m1a)
    ROLE="arn:aws:iam::405366486742:role/MerkleWebSSOAdmins"
    AWS_PROFILE=merkle-m1a
    IDP_ACCOUNT="merkle-m1a"
    ;;
merkle-m1uk)
    ROLE="arn:aws:iam::493758817293:role/MerkleWebSSOAdmins"
    AWS_PROFILE=merkle-m1uk
    IDP_ACCOUNT="merkle-m1uk"
    ;;
merkle-m1us)
    ROLE="arn:aws:iam::017052400109:role/MerkleWebSSOAdmins"
    AWS_PROFILE=merkle-m1us
    IDP_ACCOUNT="merkle-m1us"
    ;;
merkle-datb)
    ROLE="arn:aws:iam::941414724763:role/MerkleWebSSOAdmins"
    AWS_PROFILE=merkle-datb
    IDP_ACCOUNT="merkle-datb"
    ;;
merkle-search)
    ROLE="arn:aws:iam::188313933906:role/MerkleWebSSOAdmins"
    AWS_PROFILE=merkle-search
    IDP_ACCOUNT="merkle-search"
    ;;
list-roles)
    saml2aws list-roles
    return
    ;;
*)
    saml2aws login
    export AWS_PROFILE
    return
    ;;
esac
saml2aws login --role=$ROLE --idp-account=$IDP_ACCOUNT
export AWS_PROFILE
export AWS_REGION
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#zprof
