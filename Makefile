# For setting up dotfiles
#
#   make symlinks
#   make submodules
#   make

CONF_FILES := .bash_profile .bash_aliases \
	.git-prompt.bash .git-completion.bash .config/git/config \
	.screenrc .tmux.conf .vimrc .vim .perltidyrc .signature

TARGETS := $(addprefix $(HOME)/, $(CONF_FILES))

all: submodules symlinks

submodules: init
	git submodule foreach --recursive git pull origin master

symlinks: ${TARGETS} .bashrc

init:
	git submodule update --init --recursive

packages:
	sudo apt-get install build-essential cmake

${TARGETS}:
	@echo Updating link for $@
	mkdir -p $(dir $@)
	test -f $@ && mv -f $@ $@.org || true
	ln -fs $(HOME)/.dotfiles/$(subst ${HOME}/,,$@) $@

.bashrc.org:
	test -L $(HOME)/.bashrc && echo ".bashrc is already a symlink" && exit || true
	test -f $(HOME)/.bashrc.org && echo ".bashrc.org exists" && exit || true
	test ! -L $(HOME)/.bashrc && mv $(HOME)/.bashrc $(HOME)/.bashrc.org || true

.bashrc: .bashrc.org
	@echo Replacing .bashrc
	test -L $(HOME)/.bashrc && echo ".bashrc already a symlink" || \
	ln -s $(HOME)/.dotfiles/.bashrc $(HOME)/.bashrc

.PHONY: all submodules

