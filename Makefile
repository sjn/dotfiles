# For setting up dotfiles
#
#   make symlinks
#   make submodules
#   make

CONF_FILES := .bashrc .bash_profile .bash_aliases \
	.git-prompt.bash .git-completion.bash .config/git/config \
	.screenrc .tmux.conf .vimrc .vim .perltidyrc

TARGETS := $(addprefix $(HOME)/, $(CONF_FILES))

all: submodules symlinks

submodules:
	git submodule init
	git submodule update
	git submodule foreach git checkout master
	git submodule foreach git fetch --all
	git submodule foreach git rebase origin/master

symlinks: ${TARGETS}

${TARGETS}:
	test -f $@ && mv -f $@ $@.org || true
	ln -s .dotfiles/$(notdir $@) $@

.PHONY: all submodules

