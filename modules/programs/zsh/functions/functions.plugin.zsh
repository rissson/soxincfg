functions_root="${${(%):-%x}:A:h}"

# autoload all of the functions
for func in $functions_root/*; do
  local func_name="$(basename ${func})"
  case "${func_name}" in
    _*)          ;;

    *)
      autoload -U "${func_name}"
      ;;
  esac
done
unset func
