parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function prompt {
   # Append to the bash history after each command rather than on exit
   history -a
}

PROMPT_COMMAND='prompt'

export PS1="\W \$(parse_git_branch) $ "
