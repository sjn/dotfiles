# For setting up dotfiles
#
#   make symlinks
#   make submodules
#   make

CONF_FILES := .bashrc .bash_profile .bash_aliases \
	.git-prompt.bash .git-completion.bash .config/git/config \
	.screenrc .tmux.conf .vimrc .vim .perltidyrc .signature \
	.Xresources

TARGETS := $(addprefix $(HOME)/, $(CONF_FILES))

all: submodules symlinks

#git submodule update --init --recursive
submodules:
	git submodule foreach --recursive git reset --hard --quiet origin/master
	git submodule foreach --recursive git checkout master
	git submodule foreach --recursive git pull origin master

symlinks: ${TARGETS}

# ycm_client_support.so ycm_core.so
ycm:
	sudo apt-get install build-essential cmake python-dev
	git submodule update --init --recursive
	cd .vim/bundle/YouCompleteMe/ && ./install.sh --clang-completer

${TARGETS}:
	mkdir -p $(dir $@)
	test -f $@ && mv -f $@ $@.org || true
	ln -fs $(HOME)/.dotfiles/$(subst ${HOME}/,,$@) $@

.PHONY: all submodules

