function ping {

  Write-Host "pong"

}

function set_stdout {

  Param($line)

  $file = stdout_file

  $line | Out-File $file

}

function run_task {

    Param($path, $params)

    $params_json = $params | ConvertTo-Json -Depth 10

    Write-Host "task_var_json_begin"

    Write-Host $params_json

    Write-Host "task_var_json_end"

    Write-Host "task: $path"

}


# this syntax is deprecated
# use `ignore_error` instead

function ignore_task_err {

  Param($val)

  Write-Host "ignore_task_err: $val"

}

function ignore_task_err {

  Write-Host "ignore_task_err:"

}

function captures {

  $cache_root_dir = cache_root_dir

  $file = "$cache_root_dir/captures.json"

  $json = Get-Content -Raw -Path $file | ConvertFrom-Json

  return $json

}

function capture {
   $captures = captures
   return $captures[0]
}

function task_var {

  Param($Name)

  $cache_dir = cache_dir

  $file = "$cache_dir/variables.json"

  $json = Get-Content -Raw -Path $file | ConvertFrom-Json

  return $json.$Name

}

function config {

  Param($Name)

  $cache_root_dir = cache_root_dir

  $file = "$cache_root_dir/config.json"

  $json = Get-Content -Raw -Path $file | ConvertFrom-Json

  return $json.$Name

}

function streams {

  $cache_root_dir = cache_root_dir

  $file = "$cache_root_dir/streams.json"

  $json = Get-Content -Raw -Path $file | ConvertFrom-Json

  return $json

}

function streams_array {

  $cache_root_dir = cache_root_dir

  $file = "$cache_root_dir/streams-array.json"

  $json = Get-Content -Raw -Path $file | ConvertFrom-Json

  return $json

}

function get_state {

  $cache_root_dir = cache_root_dir


}


function update_state {

  Param($State)

  $cache_root_dir = cache_root_dir

  $file = "$cache_root_dir/state.json"

  $json = $State | ConvertTo-Json -Depth 10

  $json | Out-File $file


}
