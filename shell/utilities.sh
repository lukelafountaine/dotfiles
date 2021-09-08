silentPushd() {
   if [ -d "$1" ]; then
      pushd $1 2>&1 >> /dev/null
   else
      echo "No such dir: $1"
      return 1
   fi
}

silentPopd() {
   popd 2>&1 >> /dev/null
}

weather() {
   WHERE="10987"

   if [ "$1" != "" ]; then
      WHERE="$1"
      shift
   fi

   curl "v2.wttr.in/${WHERE}"
}

expandPath() {
   # From https://stackoverflow.com/a/29310477
   local path
   local -a pathElements resultPathElements
   IFS=':' read -r -a pathElements <<<"$1"
   : "${pathElements[@]}"
   for path in "${pathElements[@]}"; do
      : "$path"
      case $path in
         "~+"/*)
            path=$PWD/${path#"~+/"}
            ;;
         "~-"/*)
            path=$OLDPWD/${path#"~-/"}
            ;;
         "~"/*)
            path=$HOME/${path#"~/"}
            ;;
         "~"*)
            username=${path%%/*}
            username=${username#"~"}
            IFS=: read -r _ _ _ _ _ homedir _ < <(getent passwd "$username")
            if [[ $path = */* ]]; then
               path=${homedir}/${path#*/}
            else
               path=$homedir
            fi
            ;;
      esac
      resultPathElements+=( "$path" )
   done
   local result
   printf -v result '%s:' "${resultPathElements[@]}"
   printf '%s\n' "${result%:}"
}
