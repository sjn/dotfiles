# For setting up dotfiles

CONF_FILES := .bashrc .bash_profile .bash_aliases \
	.git-prompt.bash .git-completion.bash .gitconfig \
	.screenrc .tmux.conf .vimrc .vim .perltidyrc

TARGETS := $(addprefix $(HOME)/, $(CONF_FILES))

all: submodules ${TARGETS}

submodules:
	git submodule init
	git submodule update

${TARGETS}:
	test -f $@ && mv -f $@ $@.org || true
	ln -s .dotfiles/$(notdir $@) $@

.PHONY: all submodules

