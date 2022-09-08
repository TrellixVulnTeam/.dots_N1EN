XDG_CONFIGS := $(shell ls -A .config)
DOTFILES := $(addprefix $(HOME)/.config/,$(XDG_CONFIGS))
NVM_VERSION := 'v0.39.1'
NEOVIM_VERSION := 'v0.7.2'
TMUX_VERSION := '3.2a'

SHELL := /bin/bash

.PHONY: help
help: ## prints this help
	@grep -hE '^[\.a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "%-16s %s\n", $$1, $$2}'

.PHONY: sync
sync: do-sync helptags sync-xdg ## create symlinks to dotfiles

.PHONY: do-sync
do-sync:
	@mkdir -p ~/.config
	@mkdir -p ~/.local/state/
	@mkdir -p ~/.local/share/nvim/sessions/
	@mkdir -p ~/.local/share/nvim/site/pack/plugins/
	@mkdir -p ~/.gnupg/ && sudo chmod 700 ~/.gnupg
	@[ -h ~/.local/share/nvim/site/pack/plugins/opt ] || ln -sv $(PWD)/vim-plugins/opt ~/.local/share/nvim/site/pack/plugins/opt
	@[ -h ~/.local/share/nvim/site/pack/plugins/start ] || ln -sv $(PWD)/vim-plugins/start ~/.local/share/nvim/site/pack/plugins/start
	@[ -f ~/.bashrc ] || ln -sv $(PWD)/.bashrc ~/.bashrc
	@[ -f ~/.bash_profile ] || ln -sv $(PWD)/.bash_profile ~/.bash_profile
	@[ -f ~/.gnupg/gpg-agent.conf ] || ln -sv $(PWD)/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
	@[ -f ~/.gnupg/gpg.conf ] || ln -sv $(PWD)/.gnupg/gpg.conf ~/.gnupg/gpg.conf

.PHONY: sync-xdg
sync-xdg: | $(DOTFILES) ## create symlinks to dotfiles in ~/.config/

# This will link all of our dot files into our home directory.  The
# magic happening in the first arg to ln is just grabbing the file name
# and appending the path to dotfiles/home
$(DOTFILES):
	@ln -sv "$(PWD)/.config/$(notdir $@)" ~/.config/$(notdir $@)

.PHONY: clean
clean: ## remove symlinks to dotfiles
	@rm -fv ~/.bashrc
	@rm -fv ~/.bash_profile
	@rm -fv ~/.gnupg/gpg-agent.conf
	@rm -fv ~/.gnupg/gpg.conf
	@rm -fv ~/.local/share/nvim/site/{sessions,pack/plugins/{opt,start}}
	@for f in $(DOTFILES); do rm -rfv $$f; done

.PHONY: helptags
helptags: ## generate vim helptags
	@nvim -c ':helptags ALL' -c ':q'

BREW_TARGETS := \
	rg \
	tmux \
  git \
  protobuf \
  cmake \
  bash-completion \
  ninja \
  libtool \
  automake \
  cmake \
  pkg-config \
  gettext \
  curl \
  golang \
  pass \
  mpv \
  autoconf \
  automake \
  bash \
  binutils \
  coreutils \
  diffutils \
  ed \
  findutils \
  flex \
  git-extras \
  gawk \
  gnu-indent \
  gnu-sed \
  gnu-tar \
  gnu-which \
  grep \
  gzip \
  jq \
  less \
  libtool \
  m4 \
  make \
  nano \
  neovim \
  pinentry-mac \
	proctools \
  reattach-to-user-namespace \
  ruby \
  screen \
  git-delta \
  task \
  terminal-notifier \
  watch \
  wdiff \
  wget \
  zoxide

APT_TARGETS := \
	tmux

.PHONY: install-brew
install-brew:
	@[ -x /opt/homebrew/bin/brew ] || bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: install-macos
install-macos: install-brew install-brew-packages install-go-packages ## install macos

.PHONY: install-brew-packages
install-brew-packages:
	@brew tap homebrew/cask-fonts
	@brew install --cask font-jetbrains-mono-nerd-font
	@brew install $(BREW_TARGETS)

.PHONY: nvim-install-dependencies
nvim-install-dependencies:
	@nvim --headless -c "MasonInstall gopls typescript-language-server dockerfile-language-server" -c "qall"

.PHONY: update-macos
update-macos: install-brew install-go-packages ## update macos
	@brew update
	@brew upgrade $(BREW_TARGETS)

.PHONY: install-ubuntu
install-ubuntu: install-apt-packages install-go-packages ## install ubuntu

.PHONY: install-apt-packages
install-apt-packages:
	@sudo apt install $(APT_TARGETS)

.PHONY: install-go-packages
install-go-packages: ## install go packages
	go install github.com/mikefarah/yq/v4@latest
	go install github.com/go-delve/delve/cmd/dlv@latest
	go install github.com/posener/complete/gocomplete@latest
	go install github.com/rogpeppe/godef@latest
	go install golang.org/x/tools/...@latest

.PHONY: install-nvm
install-nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(NVM_VERSION)/install.sh | bash

.PHONY: install-neovim
install-neovim:
	pushd /tmp && \
	curl -LO https://github.com/neovim/neovim/releases/download/$(NEOVIM_VERSION)/nvim.appimage.sha256sum && \
	curl -LO https://github.com/neovim/neovim/releases/download/$(NEOVIM_VERSION)/nvim.appimage && \
	sha256sum -c nvim.appimage.sha256sum | grep OK && \
	sudo mv nvim.appimage /usr/local/bin/nvim && \
	sudo chmod +x /usr/local/bin/nvim && \
	popd

.PHONY: install-tmux
install-tmux:
	pushd /tmp && \
	curl -LO https://github.com/nelsonenzo/tmux-appimage/releases/download/$(TMUX_VERSION)/tmux.appimage && \
	sudo mv tmux.appimage /usr/local/bin/tmux && \
	sudo chmod +x /usr/local/bin/tmux && \
	popd

.PHONY: git-install-fzf
git-install-fzf:
	@rm -rf ~/.fzf
	@git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	@~/.fzf/install --all --xdg
	@source ~/.bashrc

.PHONY: install-bash-completion
install-bash-completion:
	@gocomplete -install -y
