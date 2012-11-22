# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

umask 022

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
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

# Jump through screen(1) + ssh(1) hoops
if [ ! -z "$SSH_AUTH_SOCK" ]; then
    if [ "x$SHLVL" = "x1" ]; then # we are a login shell
        echo "screen+ssh socket link: '$SSH_AUTH_SOCK'"
        rm -f "/tmp/.ssh-$USER-agent-sock-screen"
        ln -fs "$SSH_AUTH_SOCK" "/tmp/.ssh-$USER-agent-sock-screen"
        ssh-add -l
    fi
else
    for agent in /tmp/ssh-*/agent.*; do
        export SSH_AUTH_SOCK=$agent
        if ssh-add -l 2>&1 > /dev/null; then
            echo "Found working SSH Agent:"
            ln -fs "$SSH_AUTH_SOCK" "/tmp/.ssh-$USER-agent-sock-screen"
            export SSH_AUTH_SOCK="/tmp/.ssh-$USER-agent-sock-screen"
            ssh-add -l
            return
        fi
    done
    echo "No SSH agent found."
fi
export PERLTIDY=$HOME/src/runbox/conf/home/development/.perltidyrc

# RMM: Generated with local::lib
export MY_PERL_VERSION=$(perl -e 'print $]')
eval $(perl -I$HOME/perl${MY_PERL_VERSION}/lib/perl5 -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl${MY_PERL_VERSION})
umask 022

