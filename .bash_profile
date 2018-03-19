# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -d /opt/perlbrew ]; then
    export PERLBREW_ROOT=/opt/perlbrew
fi


# Generated with local::lib
export MY_PERL_VERSION=$(perl -e 'print $]')
if [ -d "$HOME/perl${MY_PERL_VERSION}/lib/perl5" -o -d "$HOME/perl5/lib/perl5" ]; then
    eval $(perl -I$HOME/perl${MY_PERL_VERSION}/lib/perl5 -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl${MY_PERL_VERSION})
fi
umask 022

# vim:filetype=sh
