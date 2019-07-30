# Task Runner API

Sparrow6 Task Runner is underlying engine to run Sparrow6 tasks,
it has 3 flavors to use:

1. DSL-like style, plugins

`task-run $task-name, $plugin-name, %parameters`

Use this method to run Sparrow6 [plugins](https://github.com/melezhik/Sparrow6/blob/master/documentation/plugins.md)

    # Runs vsts-build plugin for build definition JavaApp
    task_run "run my build", "vsts-build", %(
      definition => "JavaApp"
    );

2. DSL-like style, local tasks

`task-run $root-dir, %parameters`

Use this method to run local tasks:

    # Run default task located at the root directory utilities/animals

    task-run "utilities/animals", %( hello => 'Sparrow ');

You can run a certain task located at the root directory, by using `$root-dir@task-path` notation:

    # Run birds/tiny task located at the root directory utilities/animals:

    task-run "utilities/animals@birds/tiny", %( hello => 'Sparrow ');

3. Low level API

You probably don't need to use that explicitly, 
it's used by the first two methods _internally_

    use Sparrow6::Task::Runner;

    Sparrow6::Task::Runner::Api.new(
      name  => "bash",
      root  => "examples/plugins/bash",
      do-test => True,
      show-test-result => True,
      debug => True,
      parameters => %(
        command => 'echo $foo',
        debug   => 1,
        envvars => %(
          foo => "BAR"
        )
      )
    ).task-run;

