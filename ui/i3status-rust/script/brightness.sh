case $1 in
get)
  brightnessctl g
  ;;
max)
  brightnessctl m
  ;;
set)
  brightnessctl s "$2"
  ;;
*)
  echo "Usage: $0 {get|max|set VALUE}"
  exit 1
  ;;
esac
