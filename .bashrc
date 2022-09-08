# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# Disable flow control
stty -ixon

# Update window size after every command
shopt -s checkwinsize

# Automatically trim long paths in the prompt (requires Bash 4.x)
PROMPT_DIRTRIM=2

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Include hidden files when globbing
shopt -s dotglob

# Save multi-line commands as one command
shopt -s cmdhist

# append to the history file, don't overwrite it
shopt -s histappend

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Use a private mock hosts(5) file for completion, as we usually have
# https://github.com/StevenBlack/hosts in /etc/hosts and we don't want to
# complete all the blocked hosts
HOSTFILE=$HOME/.hosts

# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
# Examples:
# export dotfiles="$HOME/dotfiles"
shopt -s cdable_vars

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
CDPATH="."

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

color0='\[\033[00;30m\]'
color1='\[\033[00;34m\]'
color2='\[\033[00;36m\]'
color3='\[\033[00;32m\]'
color4='\[\033[00;35m\]'
color5='\[\033[00;31m\]'
color6='\[\033[00;37m\]'
color7='\[\033[00;33m\]'
color8='\[\033[01;30m\]'
color9='\[\033[01;34m\]'
color10='\[\033[01;36m\]'
color11='\[\033[01;32m\]'
color12='\[\033[01;35m\]'
color13='\[\033[01;31m\]'
color14='\[\033[01;37m\]'
color15='\[\033[01;33m\]'
esc='\[\033[00m\]'
PS1="$color15"'$([ \j -gt 0 ] && echo [\j])'"${esc}${color10}"'\u@\H'"$esc"' '"$color3"'\W'"$esc"'\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Bindings
bind '"\C-x\C-m":"terminal-menu.sh\n"'
bind '"\C-x\C-l":"!!|less\n"' # Repeat last command piped to less

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load functions
if [ -d ~/.bash_functions ]; then
  for file in ~/.bash_functions/*; do
    . "$file"
  done
fi

# This should stay in .bashrc according to `man gpg-agent`
GPG_TTY=$(tty)
export GPG_TTY

# Use gpg-agent in place of ssh-agent
if [[ -z "$SSH_CLIENT" ]]; then
  SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  export SSH_AUTH_SOCK
  gpgconf --launch gpg-agent
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

# twilio autocomplete setup
TWILIO_AC_BASH_SETUP_PATH=$HOME/.twilio-cli/autocomplete/bash_setup && test -f $TWILIO_AC_BASH_SETUP_PATH && source $TWILIO_AC_BASH_SETUP_PATH;

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Aliases
alias ls="ls --color=auto"
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias ll='ls -alF'

alias js='jobs'

alias nnn='nnn -H -e'

alias g="git"
alias k="kubectl"

alias :e="$EDITOR"

# cd (cXXX)
alias cdot="cd $HOME/.dots"

# Docker (dX[X])
alias ds="docker stop"
alias drm="docker rm"
alias dt="docker start"
alias dps="docker ps"
alias dsa='docker stop $(docker ps -a -q)'
alias dra='docker rm $(docker ps -a -q)'
alias da="docker attach --sig-proxy=false"
alias dl="docker logs"
alias dlf="docker logs -f"

# Docker compose (dc[XX])
alias dc="docker-compose"
alias dcl="docker-compose logs"
alias dcu="docker-compose up"
alias dcud="docker-compose up -d"
alias dcb="docker-compose build"
alias dcs="docker-compose stop"
alias dcd="docker-compose down"

# Go (go[XX])
alias got="go test"
alias gota="go test ./..."
alias goda="go doc -all -u"
alias gomv="go mod vendor"
alias gomt="go mod tidy"
alias gomd="go mod download"

# Git (g[XXX])
alias ga="git add"
alias gl="tig log"
alias gaa="git add . && git status"
alias gp="git push"
alias gc="git commit -v"
alias gch="git checkout"
alias gchb="git checkout -b"
alias gs="git status"
alias gf="git fetch"
alias gu="git pull"
alias gd="git diff"
alias gds="git diff --staged"
alias gm="git merge"
alias gst="git stash"
alias gstp="git stash push"
alias gsto="git stash pop"
alias gzm="git-merge"
alias gzh="git-checkout"
alias gcd='cd $(git rev-parse --show-toplevel)'

# Go
alias missedlines='grep -v -e " 1$" cover.out'

# Pass pa[XX]
alias pac='pass show -c'
alias pas='pass show'
alias pag='pass generate -c'
alias pai='pass insert'

# JWT
alias decode-jwt-header="decode-jwt 1"
alias decode-jwt-payload="decode-jwt 2"

alias rbash="source $HOME/.bashrc"
alias rzsh="source $HOME/.zshrc"

alias lynx="lynx -vikeys"
alias savelast='echo !! >> ~/wiki/notes.txt'

# Functions
function cd {
  builtin cd "$@" && ls -F --color=always
}

# function nvim {
#   editor="$(which nvim)"
#   NVIM_LISTEN_ADDRESS=/tmp/nvimsocket "$editor" $@ ~/wiki/notes.txt 
# }

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash

[ -f ~/.dots/bin/sync-history.sh ] && source ~/.dots/bin/sync-history.sh
