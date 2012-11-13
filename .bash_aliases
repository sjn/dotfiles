#
# Nyttige perl-baserte aliaser
#
 
alias hex2int='perl -le "print join(qq(\n),map {hex}@ARGV)"'
alias int2hex='perl -e printf\ \"%lx\\n\",\$_\ foreach\ @ARGV'
alias urlencode='perl -ple "s/([^a-zA-Z0-9_.-])/uc sprintf(qq(%%%02x),ord(\$1))/eg"'
alias urldecode='perl -ple "s/%([0-9a-fA-F]{2})/chr hex(\$1)/ge"'
alias inet_aton='perl -MSocket -ple "s/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/unpack(q{N*},inet_aton(\$1))/ge"'
alias inet_ntoa='perl -MSocket -ple "s/(\d+)/inet_ntoa(pack(q{N*},\$1))/ge"'
alias inet_xtoa='perl -MSocket -ple "s/(?:0x)?([0-9a-fA-F]{8})/inet_ntoa(pack(q{N*},eval("0x\$1")))/ge"'
alias number_ranges='perl -le "\$_=join q(:),map{chomp;\$_;}<>;1 while s/(\d+):(\d+)/\$1.(qw(, -))[\$1+1==\$2].\$2/e;s/-[^,]+-/-/g;s/,/\n/g;print"'
alias rot13='perl -pe "y/n-za-mN-ZA-M/a-zA-Z/"'
alias scramble='perl -Mlocale -pe "s|\B\w+\B|join q(),sort{rand 2}$&=~/./g|ge"'
alias ldapdecode='perl -MMIME::Base64 -MEncode -pe "m/^(\S+::\s+)(\S*)$/ and \$_=\$1.decode_utf8(decode_base64(\$2)).qq(\n)"'
alias utf2latin1='perl -pe "s/([\xC2\xC3])([\x80-\xBF])/ord$1==0xC2?\$2:chr(ord\$2|0xC0)/ge"'
alias base64enc='perl -MMIME::Base64 -e "print encode_base64(join(q(),<>),q())"'
alias base64dec='perl -MMIME::Base64 -e "print decode_base64(join(q(),<>))"'

#
# SSH aliases
#
alias ping.uio='/usr/bin/ssh -4 -C -g -t -L3128:localhost:3128 -l sjn login.ping.uio.no'
alias hagbart.nvg='ssh -2 -4 -C -t -A -l sjn hagbart.nvg.ntnu.no'
alias decibel.pvv='ssh -2 -4 -C -t -A -l sjn decibel.pvv.ntnu.no'
alias hagbart.nvg-s='ssh -2 -4 -C -t -A -l sjn hagbart.nvg.ntnu.no screen -Ux'
alias nuug.no='ssh -2 -4 -C -t -A -l sjn nerdhaven.nuug.no'
alias ssh-recover-agent='export SSH_AUTH_SOCK=$(for SSH_AUTH_SOCK in $(find /tmp/ssh-* -user `whoami` -name agent\* 2>&- ); do ssh-add -l 1>&2 && echo "$SSH_AUTH_SOCK" && break; done;); test -S "$SSH_AUTH_SOCK" -a -r "$SSH_AUTH_SOCK" && ln -sf "$SSH_AUTH_SOCK" "$HOME/.screen-ssh-agent"'


#
# Shell-kommandoer
#

alias 000="chmod 000"
alias 400="chmod 400"
alias 440="chmod 440"
alias 444="chmod 444"
alias 500="chmod 500"
alias 550="chmod 550"
alias 555="chmod 555"
alias 600="chmod 600"
alias 640="chmod 640"
alias 644="chmod 644"
alias 660="chmod 660"
alias 664="chmod 664"
alias 666="chmod 666"
alias 700="chmod 700"
alias 740="chmod 740"
alias 744="chmod 744"
alias 750="chmod 750"
alias 754="chmod 754"
alias 755="chmod 755"
alias 770="chmod 770"
alias 774="chmod 774"
alias 775="chmod 775"
alias 777="chmod 777"
alias 7755="chmod 7755"
alias 7750="chmod 7750"

alias arm='( ls *~ .*~ \#*\# dead.letter core core.* .#* 2>&- ) | xargs rm -f'
alias devnull='cat > /dev/null'
alias cls='echo -n \e[0r\e[0m\e[H\e[J'


#
# Andre aliaser
#

alias rm='rm -i'
alias m='less -MQR'


#
# Prosess-relaterte Aliaser
#

alias z='bg'
alias massacre='kill -1 -1'

#
# Annet gurba
#
alias temp='test -e /opdata/normet/hybrid/blindva.hyb && ( tail -n1 /opdata/normet/hybrid/blindva.hyb | awk "{print \$1 \" UTC: \" \$4 \"ºC\"}" )'
shopt -s checkwinsize

alias go=gnome-open

#
# Functions
#

function ema {
   nohup /usr/bin/emacs $@ >/dev/null &
}

function w {
   /usr/bin/w $@ | sort | more
}

function who {
   /usr/bin/who $@ | sort | more
}

dotfiles='bashrc,bash_profile,aliases,screenrc,bash_aliases,vimrc,irssi/config'

function pull-dotfiles-from () {
  if [ -z $1 ]; then
    echo -e "Usage:\n    $FUNCNAME [user@]hostname [ssh-args]";
    return 1
  else
    echo "Backing up before pull";
    mkdir -p $HOME/.dotfiles-backup;
    eval '( cd $HOME; ls -1d .{'$dotfiles'} 2>&- ) | xargs tar cf $HOME/.dotfiles-backup/$(date +dotfiles-%Y-%m-%dT%H%M%S.tgz)';
    echo "Pulling"
    cd $HOME;
    ssh $2 $1 'eval "cd $HOME; ls -1d .{'$dotfiles'} 2>&- | xargs tar cf -"' | tar xf -;
    echo "Done."
  fi
}

function push-dotfiles-to () {
  if [ -z $1 ]; then
    echo -e "Usage:\n    $FUNCNAME [user@]hostname [ssh-args]";
    return 1
  else
    echo "Backing up before push";
    ssh $1 'mkdir -p $HOME/.dotfiles-backup; ( cd $HOME; ls -1d .{'$dotfiles'} 2>&- ) | xargs tar cf $HOME/.dotfiles-backup/$(date +dotfiles-%Y-%m-%dT%H%M%S.tgz)';
    echo "Pushing"
    eval "cd $HOME; ls -1d .{$dotfiles} 2>&-" | xargs tar cf - | ssh $2 $1 tar xf -;
    echo "Done."
  fi
}

#
# Custom completion for push-* and pull-* if bash_completion.sh is loaded
#
#if [ ! -z "$BASH_COMPLETION" ]; then
#    echo "Using completion for dotfile functions: $BASH_COMPLETION"
#    shopt -u hostcomplete && complete -F _user_at_host $nospace pull-dotfiles-from push-dotfile-to
#else
#    echo "No completion for dotfile functions: $BASH_COMPLETION"
#fi


#
# The End
#
