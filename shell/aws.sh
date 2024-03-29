export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1

alias awsunset='unset $(env | grep AWS | grep -v AWS_REGION | grep -v AWS_DEFAULT_REGION | sed '"'"'s|=.*||'"'"')'

function assume {
   source assume $@
   # Serverless (SLS) fails when AWS_PROFILE is set, so we unset it here
   unset AWS_PROFILE
}

# For awsume (https://awsu.me)
alias awsume=". awsume"

_awsume() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(awsume-autocomplete)
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _awsume awsume
