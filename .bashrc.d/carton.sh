#  Bash completion for carton:
#
#  carton bundle
#  carton exec
#  carton help
#  carton install
#
# Github: https://github.com/jonasbn/bash_completion_carton
# Copyright Jonas B. Nielsen (jonasbn) 2016-2017
# MIT License

_carton() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #
    #  The basic options we can complete
    #
    opts="bundle exec help install"

    #
    #  Complete the arguments to some of the basic commands.
    #
    if [[ "${prev}" == "install" ]] ; then
        local installopts="--deployment --cached"
        COMPREPLY=( $(compgen -W "${installopts}" -- ${cur}) )
        return 0
    elif [[ "${prev}" == "exec" ]] ; then
        COMPREPLY=($(for i in $(compgen -f -d -- ${cur}); do if test -d "$i"; then echo "$i/"; elif test -x "$i"; then echo "$i "; fi; done));
        test -d "${COMPREPLY[0]}" && compopt -o nospace
        return 0
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _carton carton
