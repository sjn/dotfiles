# For setting up dotfiles

CONF_FILES := .bashrc .bash_profile .bash_aliases \
	.git-prompt.bash .git-completion.bash .gitconfig \
	.screenrc .tmux.conf .vimrc .vim .perltidyrc

TARGETS := $(addprefix $(HOME)/, $(CONF_FILES))
SOURCES := $(addprefix $(HOME)/.dotfiles/, $(CONF_FILES))

submodules:
	git submodule init
	git submodule update

install: ${TARGETS}

${TARGETS}:
	ln -s .dotfiles/$(notdir $@) $@

all: submodules install

.PHONY: install submodules

