if test -f "${cache_dir}/variables.bash"; then
  source "${cache_dir}/variables.bash"
fi

function set_stdout {
  echo $* 1>>"${stdout_file}"
}

# this syntax is deprecated
# use `ignore_error` instead

function ignore_task_error {
  echo ignore_task_error:
}

function ignore_error {
  echo ignore_error:
}

function ignore_task_check_error {
  echo ignore_task_check_error:
}

function run_task {

  task_to_run=$1
  shift

  while [[ $# > 0 ]]
  do
  key="$1"
  shift
  value="$1"
  shift
  echo "task_var_bash: ${key} ${value}"
  done

  echo task: $task_to_run

}


function config {
   perl6 -I "${cache_dir}" -Msparrow6common -e json-var "${cache_root_dir}/config.json" $1
}

function task_var {
   perl6 -I "${cache_dir}" -Msparrow6common -e json-var "${cache_dir}/variables.json" $1
}

if test -f "${task_dir}/common.bash"; then
  source "${task_dir}/common.bash"
fi

if test -f "${root_dir}/common.bash"; then
  source "${root_dir}/common.bash"
fi

