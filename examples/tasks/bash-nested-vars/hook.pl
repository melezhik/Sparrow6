run_task "bash-nested-vars",{
  foo => {
    bar => {
      baz => "wow"
    }
  }
}
