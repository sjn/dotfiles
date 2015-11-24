# For setting up dotfiles
#
#   make symlinks
#   make submodules
#   make

CONF_FILES := .bashrc .bash_profile .bash_aliases \
	.git-prompt.bash .git-completion.bash .config/git/config \
	.screenrc .tmux.conf .vimrc .vim .perltidyrc .signature

TARGETS := $(addprefix $(HOME)/, $(CONF_FILES))

all: submodules symlinks

submodules: init
	git submodule foreach --recursive git pull origin master

symlinks: ${TARGETS}

# ycm_client_support.so ycm_core.so
ycm:
	git checkout master .vim/bundle/YouCompleteMe
	git submodule update --init --recursive .vim/bundle/YouCompleteMe
	git submodule foreach --recursive git checkout master
	cd .vim/bundle/YouCompleteMe/ && ./install.sh --clang-completer

init:
	git submodule update --init --recursive

packages:
	sudo apt-get install build-essential cmake python-dev

${TARGETS}:
	mkdir -p $(dir $@)
	test -f $@ && mv -f $@ $@.org || true
	ln -fs $(HOME)/.dotfiles/$(subst ${HOME}/,,$@) $@

.PHONY: all submodules

