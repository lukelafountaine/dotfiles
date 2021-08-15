weather() {
   WHERE="10987"

   if [ "$1" != "" ]; then
      WHERE="$1"
      shift
   fi

   curl "v2.wttr.in/${WHERE}"
}
