export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Set path before sourcing .bashrc
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin/:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.npm-global/bin

export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}"/readline/inputrc
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"

# Make osx use gnu versions if available
if type brew &>/dev/null; then
  HOMEBREW_PREFIX=$(brew --prefix)
  # gnubin; gnuman
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do export PATH=$d:$PATH; done
  for d in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do export MANPATH=$d:$MANPATH; done
fi


# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# Add our dotfiles scripts to path
if [ -d "$HOME/.dots/bin" ] ; then
  PATH="$HOME/.dots/bin:$PATH"
fi

# Add any home directory scripts to path
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Try to find bash completion on macos
[[ -r /usr/local/etc/bash_completion ]] && . /usr/local/etc/bash_completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
[[ -r "/opt/homebrew/etc/bash_completion" ]] && . "/opt/homebrew/etc/bash_completion"

export VISUAL='nvim'
export EDITOR='nvim'
export ALTERNATE_EDITOR=""


export LESS="--quit-if-one-screen \
  --ignore-case \
  --jump-target=5 \
  --status-column \
  --LONG-PROMPT \
  --RAW-CONTROL-CHARS \
  --HILITE-UNREAD \
  --tabs=4 \
  --no-init \
  --window=-4"

# Set colors for less. Borrowed from https://wiki.archlinux.org/index.php/Color_output_in_console#less .
export LESS_TERMCAP_mb=$'\E[1;38m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;37m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GO111MODULE=on
export PATH=$PATH:$GOBIN

export FZF_DEFAULT_COMMAND="find -L . -type f ! -path '*/.git/*'"

export PASSWORD_STORE_ENABLE_EXTENSIONS=true
export PASSWORD_STORE_DIR="$HOME/.password-store"

export GOSUMDB=off
export GOPROXY=direct
export GOPRIVATE=github.com/geckoboard

# Allow resuming jobs by their name. This means if you've bg'd nvim, running
# `nvim` again will fg it rather than start a new instance.
# If multiple matches, most recent job is chosen
# To start a new instance use \nvim
export auto_resume=substring

complete -C "$HOME"/go/bin/gocomplete go

if [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
