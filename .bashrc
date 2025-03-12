# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    [ "${PATH#*:$HOME/bin}" == "$PATH" ] && export PATH="$PATH:$HOME/bin"
fi

# do the same with MANPATH
if [ -d ~/man ]; then
    MANPATH=~/man:"${MANPATH}"
fi

# add sbin dirs
if [ -d /usr/local/sbin ]; then
    [ "${PATH#*:/usr/local/bin}" == "$PATH" ] && export PATH="$PATH:/usr/local/bin"
fi
if [ -d /usr/sbin ]; then
    [ "${PATH#*:/usr/sbin}" == "$PATH" ] && export PATH="$PATH:/usr/sbin"
fi
if [ -d /sbin ]; then
    [ "${PATH#*:/sbin}" == "$PATH" ] && export PATH="$PATH:/sbin"
fi

# if we have a dumb terminal, let's not do all the preparations below
[ "$TERM" = 'dumb' ] && return

# perlomni.vim bin path
if [ -d "${HOME}/.vim/bundle/perlomni/bin" ]; then
    PATH="${PATH}:${HOME}/.vim/bundle/perlomni/bin"
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}erasedups
# ... or force ignoredups and ignorespace
#HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s histreedit
shopt -u histverify
shopt -s cmdhist
shopt -u lithist

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=30000
HISTTIMEFORMAT=%s

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
export LC_MESSAGES=C
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
    source ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

if [ -d $HOME/.bash_completion.d ] && ! shopt -oq posix; then
    source $HOME/.bash_completion.d/bash_completion.sh
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
        #PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/"${HOME}"/~} (${TTY/\/dev\//})\007"; history -a; history -n'
        PROMPT_COMMAND='history -a; history -n'
        ;;
    *)
        ;;
    esac

    if [ -f $HOME/.git-prompt.bash -a -f $HOME/.git-completion.bash ] && ! shopt -oq posix && which git 2>/dev/null >/dev/null ; then
        source $HOME/.git-prompt.bash
        source $HOME/.git-completion.bash
        export GIT_PS1_SHOWUPSTREAM="auto"
        export GIT_PS1_SHOWDIRTYSTATE="yes"
        export PS1="${debian_chroot:+($debian_chroot)}\t \[\033[1;31m\]\u@\h\[\033[0m\]\[\033[1;32m\]\$(__git_ps1 ' %s')\[\033[0m\] \W \$?\$ "
    else
        export PS1="${debian_chroot:+($debian_chroot)}\t \[\033[1;31m\]\u@\h\[\033[0m\] \W \$?\$ "
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

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|xterm-256color)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#for cpanroot in /var/store/CPAN /opt/minicpan/CPAN /home/minicpan/CPAN; do
#    if [ -d $cpanroot ]; then
#        export PERL_CPANM_OPT="--mirror file://$cpanroot"
#        break
#    fi
#done

if [ -f $HOME/src/.perltidyrc ]; then
    export PERLTIDY=$HOME/src/.perltidyrc
fi

# Komodo stuff
if [ -f $HOME/bin/Komodo-IDE-8/bin ]; then
    export PATH="$HOME/bin/Komodo-IDE-8/bin:$PATH"
fi

# plenv(1) path (perlbrew alternative)
if [ -f $HOME/.plenv/bin/plenv ]; then

   export PATH="$HOME/.plenv/bin:$PATH"
   eval "$(plenv init -)"
   export PERL_ENV_LOADED="$HOME/.plenv"


elif [ -f $HOME/perl5/perlbrew/etc/bashrc ]; then

   source $HOME/perl5/perlbrew/etc/bashrc
   export PERL_ENV_LOADED="$HOME/perl5/perlbrew"

fi

# Look for local::lib env in any case
if [ -d $HOME/perl5 ]; then

    for perllibdir in $HOME/perl5; do
        if [ -d $perllibdir/lib/perl5 ]; then
            eval "$(perl -I$perllibdir/lib/perl5 -Mlocal::lib)"
			export PERL_ENV_LOADED="${PERL_ENV_LOADED}:$perllibdir/lib/perl5"
            break
        fi
    done

fi

if [ -f $HOME/.gnupg/secring.gpg ]; then
   GPGKEY=B14126EA
fi

# https://rakubrew.org/ (replaces rakudobrew)
if [ -d $HOME/.rakubrew ]; then
   eval "$(/home/sjn/.rakubrew/bin/rakubrew init -)"
fi

if [ -d /opt/rakudo/bin ]; then

   [ "${PATH#*:/opt/rakudo/bin}" == "$PATH" ] && export PATH="$PATH:/opt/rakudo/bin"
   [ "${PATH#*:/opt/rakudo/share/perl6/site/bin}" == "$PATH" ] && export PATH="$PATH:/opt/rakudo/share/perl6/site/bin"
   [ "${PATH#*:/opt/rakudo/share/perl6/core/bin}" == "$PATH" ] && export PATH="$PATH:/opt/rakudo/share/perl6/core/bin"

elif [ -d $HOME/.p6env/bin ]; then

   PATH="${HOME}/.p6env/bin:${PATH}"
   eval "$(p6env init -)"

elif [ -d $HOME/.rakudo/bin ]; then

   [ "${PATH#*:$HOME/.rakudo/bin}" == "$PATH" ] && export PATH="$PATH:$HOME/.rakudo/bin"
   [ "${PATH#*:$HOME/.rakudo/share/perl6/site/bin}" == "$PATH" ] && export PATH="$PATH:$HOME/.rakudo/share/perl6/site/bin"
   [ "${PATH#*:$HOME/.rakudo/share/perl6/core/bin}" == "$PATH" ] && export PATH="$PATH:$HOME/.rakudo/share/perl6/core/bin"

fi

if [ -d $HOME/.local/bin ]; then
   [ "${PATH#*:$HOME/.local/bin}" == "$PATH" ] && export PATH="$PATH:$HOME/.local/bin"
fi

# Pager environment (for more useful defaults)
export PAGER="less -+c -e"

if [ -d $HOME/.bashrc.d ]; then
   for rcfile in $HOME/.bashrc.d/*.sh; do
      source $rcfile
   done
fi

# Node's "n" install tool
if [ -d $HOME/.node-n ]; then
   export N_PREFIX="$HOME/.node-n"
fi

# Direnv
if [ "X$(type -t direnv)" = "Xfile" ]; then

   eval "$(direnv hook bash)"

fi

if [ -d $HOME/.pyenv ] && [ "fileX" = "$(type -t $HOME/.pyenv/bin/pyenv)X" ]; then

   PATH="${HOME}/.pyenv/bin:${PATH}"
   # added by Webi for pyenv
   eval "$(pyenv init -)"
   eval "$(pyenv virtualenv-init -)"

   # Generated for envman. Do not edit.
   [ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
fi

# Clean up PATH

OLDPATH="$PATH"; NEWPATH=""; colon=""
while [ "${OLDPATH#*:}" != "$OLDPATH" ]
do  entry="${OLDPATH%%:*}"; search=":${OLDPATH#*:}:"
    [ "${search#*:$entry:}" == "$search" ] && NEWPATH="$NEWPATH$colon$entry" && colon=:
    OLDPATH="${OLDPATH#*:}"
done
NEWPATH="$NEWPATH:$OLDPATH"
export PATH="$NEWPATH"
unset OLDPATH NEWPATH
