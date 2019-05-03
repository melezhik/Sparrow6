function bash_rocks {
  echo bash rocks!
  echo OK
  config_main_foo
}

function config_main_foo {
  echo $(config main.foo)
}

function set_Foo {
  FOO=101
}
