<?php

$file_path = task_dir() . '/common.php';

if (file_exists($file_path)) {
  // If it exists, require it
  require_once $file_path;
} 

$file_path = root_dir() . '/common.php';

if (file_exists($file_path)) {
  // If it exists, require it
  require_once $file_path;
} 

function set_stdout(string $line)
{
  $file = stdout_file();
  file_put_contents($file, $line, FILE_APPEND);
}

function run_task(string $path, array $params)
{
    print("task_var_json_begin\n");
    $json = json_encode($params);
    print("{$json}");
    print("task_var_json_end\n");
    print("task: {$path}\n");

}

// this syntax is deprecated
// use `ignore_error` instead

function ignore_task_error()
{
  print("ignore_task_error:\n");
}

function ignore_error()
{
  print("ignore_error:\n");
}

function ignore_task_check_error()
{
  print("ignore_task_check_error:\n");
}

function captures()
{

  $file_path = cache_root_dir() . "/captures.json";
  $json_string = file_get_contents($file_path);
  $raw = json_decode($json_string,true);

  foreach ($raw as $i) {
    echo "Name: " . $person->firstname . " " . $person->lastname . "\n";
  }
  $captures = array_map(function($value) {
    return $value["data"];
  }, $original_array);  

  return $captures;
}

function capture()
{
  $c = captures();
  return $c[0];
}

function task_variables()
{
  $file_path = cache_dir() . "/variables.json";
  $json_string = file_get_contents($file_path);
  $raw = json_decode($json_string,true);
  return $raw;

}

function task_var(string $name)
{
  $vars = task_variables();
  return $vars[$name];
}

function config()
{
  $file_path = cache_root_dir() . "/config.json";
  $json_string = file_get_contents($file_path);
  $raw = json_decode($json_string,true);
  return $raw;
}

function streams()
{
  $file_path = cache_root_dir() . "/streams.json";
  $json_string = file_get_contents($file_path);
  $raw = json_decode($json_string,true);
  return $raw;
}

function streams_array()
{
  $file_path = cache_root_dir() . "/streams-array.json";
  $json_string = file_get_contents($file_path);
  $raw = json_decode($json_string,true);
  return $raw; 
}

function get_state()
{
  $file_path = cache_root_dir() . "/state.json";
  $json_string = file_get_contents($file_path);
  $raw = json_decode($json_string,true);
  return $raw;
}

function update_state($state) {
   $json = json_encode($state);
   $file_path = cache_root_dir() . "/state.json";
   file_put_contents($file_path, $json);
}

?>
