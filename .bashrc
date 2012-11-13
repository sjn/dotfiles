# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
#HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

export LANG=nb_NO.utf8
export LOCALE=nb_NO.utf8
export LESSCHARSET='utf-8'


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


#### Salve sitt

# If running interactively, then:
if [ "$PS1" ]; then

    # don't put duplicate lines in the history. See bash(1) for more options
    #CDPATH='.:~:/usr'
    export FIGNORE='~'
    #export CDPATH

    # some more ls aliases
    alias m='less -MQr'

    # set a fancy prompt
    #PS1='\u@\h:\w\$ '
    PS1="\t (\u@\h) \W <\$?>"

    # If this is an xterm set the title to user@host:dir
    case $TERM in
    xterm*)
        TTY=`tty`
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/"${HOME}"/~} (${TTY/\/dev\//})\007"'
        #TERM='xterm-color'
        TERM='xterm-256color'
        ;;
    *)
        ;;
    esac

    set show-all-if-ambiguous on
    set bell-style visible
    set mark-symlinked-directories on
    set mark-directiories on
    set match-hidden-files off

    CVS_RSH=ssh
    EDITOR=/usr/bin/vim
    VISUAL=$EDITOR
    CVSEDITOR=$EDITOR

    export CVS_RSH EDITOR CVSEDITOR VISUAL TERM

fi

if [ -d $HOME/perl5/lib/perl5 ]; then

   eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)

fi

if [ -f $HOME/perl5/perlbrew/etc/bashrc ]; then

   source $HOME/perl5/perlbrew/etc/bashrc

fi

if [ -d /var/store/CPAN ]; then
    export PERL_CPANM_OPT="--mirror file:///var/store/CPAN/"
fi

test -S "$SSH_AUTH_SOCK" -a -r "$SSH_AUTH_SOCK" && ln -sf "$SSH_AUTH_SOCK" "$HOME/.screen-ssh-agent" || echo "Could not update .screen-ssh-agent"
