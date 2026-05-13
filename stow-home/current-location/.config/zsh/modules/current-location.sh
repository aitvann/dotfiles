# define an array to collect functions run only once
typeset -ag self_destruct_functions=()
function _self_destruct_hook {
  local f
  for f in ${self_destruct_functions}; do
    "$f"
  done

  # remove self from precmd
  precmd_functions=(${(@)precmd_functions:#_self_destruct_hook})
  builtin unfunction _self_destruct_hook
  unset self_destruct_functions
}

precmd_functions=(_self_destruct_hook ${precmd_functions[@]})

# write current location
function update_cwd_file() {
  current_pid=$(echo $$)
  current-location write zsh $PWD $current_pid
}

add-zsh-hook -Uz chpwd update_cwd_file

# chpwd hook is not triggered on startup by design so we trigger it once manually
self_destruct_functions=(${self_destruct_functions[@]} update_cwd_file)
