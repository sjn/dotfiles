# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# load original .bashrc, if it exists
if [ -f ~/.bashrc.org ]; then
    . ~/.bashrc.org
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# do the same with MANPATH
if [ -d ~/man ]; then
    MANPATH=~/man:"${MANPATH}"
fi

# add sbin dirs
if [ -d /usr/local/sbin ]; then
    PATH="${PATH}":/usr/local/sbin
fi
if [ -d /usr/sbin ]; then
    PATH="${PATH}":/usr/sbin
fi
if [ -d /sbin ]; then
    PATH="${PATH}":/sbin
fi

if [ -d $HOME/perl6/bin ]; then
    PATH="${PATH}":$HOME/perl6/bin
fi

# if we have a dumb terminal, let's not do all the preparations below
[ "$TERM" = 'dumb' ] && return

# perlomni.vim bin path
if [ -d "${HOME}/.vim/bundle/perlomni/bin" ]; then
    PATH="${PATH}:${HOME}/.vim/bundle/perlomni/bin"
fi

# Jump through screen(1) + ssh(1) hoops
if [ ! -z "$SSH_AUTH_SOCK" ]; then
    if [ "x$SHLVL" = "x1" ]; then # we are a login shell
        #echo "screen+ssh socket link: '$SSH_AUTH_SOCK'" 1>&2
        rm -f "/tmp/.ssh-$USER-agent-sock-screen"
        ln -fs "$SSH_AUTH_SOCK" "/tmp/.ssh-$USER-agent-sock-screen"
        #ssh-add -l 1>&2
    fi
else
    for agent in /tmp/ssh-*/agent.*; do
        export SSH_AUTH_SOCK=$agent
        if ssh-add -l >/dev/null 2>&1 ; then
            #echo "Found working SSH Agent:" 1>&2
            ln -fs "$SSH_AUTH_SOCK" "/tmp/.ssh-$USER-agent-sock-screen"
            export SSH_AUTH_SOCK="/tmp/.ssh-$USER-agent-sock-screen"
            #ssh-add -l 1>&2
            return
        fi
    done
    #echo "No SSH agent found." 1>&2
fi


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
#HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=3000
HISTTIMEFORMAT=yes

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# Detect colors
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'. Assuming 256 colors" 1>&2
            TERM="xterm-256color"
        else
            case "$XTERM_VERSION" in
            "XTerm(312)") TERM="xterm-256color" ;;
            "XTerm(256)") TERM="xterm-256color" ;;
            "XTerm(88)") TERM="xterm-88color" ;;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION" 1>&2
                ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="xterm-256color"
                #TERM="gnome-256color"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM" 1>&2
                ;;
        esac
    fi
elif [ "$TERM" = "screen" ] ; then
    # Let's try to use a color terminal by default
    TERM="screen-256color"
fi

SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'." 1>&2
            export TERM=screen-bce
            ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'." 1>&2
            export TERM=xterm-88color
            ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'." 1>&2
            export TERM=xterm-256color
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            echo "Unknown terminal $TERM. Falling back to 'xterm'." 1>&2
            export TERM=xterm
            ;;
        rxvt*)
            echo "Unknown terminal $TERM. Falling back to 'rxvt'." 1>&2
            export TERM=rxvt
            ;;
        screen*)
            echo "Unknown terminal $TERM. Falling back to 'screen'." 1>&2
            export TERM=screen
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi



# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    *color*) color_prompt=yes;;
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
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

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
TTY=`tty`

# If running interactively, then:
if [ "$PS1" ]; then

    # Don't tab-complete to filenames with the following suffixes
    export FIGNORE='~:.bak:.old'

    # some more ls aliases
    alias m='less -MQr'

    # If this is an xterm set the title to user@host:dir
    case $TERM in
    screen*|gnome*|xterm*|rxvt*)
        TTY=`tty`
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/"${HOME}"/~} (${TTY/\/dev\//})\007"; history -a; history -n'
        ;;
    *)
        ;;
    esac

    if [ -f $HOME/.git-prompt.bash -a -f $HOME/.git-completion.bash ] && ! shopt -oq posix && which git 2>/dev/null >/dev/null ; then
        . $HOME/.git-prompt.bash
        . $HOME/.git-completion.bash
        export GIT_PS1_SHOWUPSTREAM="auto"
        export GIT_PS1_SHOWDIRTYSTATE="yes"
        PS1="${debian_chroot:+($debian_chroot)}\t \[\033[1;31m\]\u@\h\[\033[0m\]\[\033[1;32m\]\$(__git_ps1 ' %s')\[\033[0m\] \W \$?\$ "
    else
        PS1="${debian_chroot:+($debian_chroot)}\t \[\033[1;31m\]\u@\h\[\033[0m\] \W \$?\$ "
    fi

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

for perllibdir in $HOME/perl5; do
    if [ -d $perllibdir/lib/perl5 ]; then

        eval $(perl -I$perllibdir/lib/perl5 -Mlocal::lib)
        export PATH=${PATH}:$perllibdir/bin
        break

    fi
done

if [ -z "$PERLBREW_ROOT" -a -f $HOME/perl5/perlbrew/etc/bashrc ]; then

   source $HOME/perl5/perlbrew/etc/bashrc

fi

for cpanroot in /var/store/CPAN /opt/minicpan/CPAN /home/minicpan/CPAN; do
    if [ -d $cpanroot ]; then
        export PERL_CPANM_OPT="--mirror file://$cpanroot"
        break
    fi
done

if [ -f $HOME/src/runbox/conf/home/development/.perltidyrc ]; then
    export PERLTIDY=$HOME/src/runbox/conf/home/development/.perltidyrc
fi

# Bash::Complete
if [ -f $HOME/perl5/bin/setup-bash-complete ]; then
    source $HOME/perl5/bin/setup-bash-complete
fi

# Komodo stuff
if [ -f $HOME/bin/Komodo-IDE-8/bin ]; then
    export PATH="$HOME/bin/Komodo-IDE-8/bin:$PATH"
fi

# plenv(1) path (perlbrew alternative)
if [ -f $HOME/.plenv/bin/plenv ]; then
   export PATH="$HOME/.plenv/bin:$PATH"
   eval "$(plenv init -)"
fi

if [ -f $HOME/.gnupg/secring.gpg ]; then
   GPGKEY=B14126EA
fi

if [ -d $HOME/.rakudobrew ]; then
   eval "$(/home/sjn/.rakudobrew/bin/rakudobrew init -)"
fi

# Pager environment (for more useful defaults)
export PAGER="less -+C -E -R"

