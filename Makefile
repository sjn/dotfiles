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

${TARGETS}:
	mkdir -p $(dir $@)
	test -f $@ && mv -f $@ $@.org || true
	ln -fs $(HOME)/.dotfiles/$(subst ${HOME}/,,$@) $@

.PHONY: all submodules

