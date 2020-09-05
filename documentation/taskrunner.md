# Task Runner API

Sparrow Task Runner is underlying engine to run Sparrow6 tasks, it has 3 flavors to use:

1. DSL-like style, plugins

`task-run $task-name, $plugin-name, %parameters`

Use this method to run Sparrow6 [plugins](https://github.com/melezhik/Sparrow6/blob/master/documentation/plugins.md)

    # Runs vsts-build plugin for build definition JavaApp
    task_run "run my build", "vsts-build", %(
      definition => "JavaApp"
    );

2. DSL-like style, local tasks

`task-run $task-dir, %parameters`

Use this method to run local tasks:

    # Run default task located at the task directory ./utilities/animals

    task-run "utilities/animals", %( hello => 'Cow ');

You can run specific task located at the task directory, by using `$task-dir@task-path` notation:

    # Run birds/tiny task located at the task directory ./utilities/animals:

    task-run "utilities/animals@birds/tiny", %( hello => 'Sparrow ');

You can set task root directory to add alternative location where local tasks are searched:

    SP6_TASK_ROOT=~/tasks

Then following task will be searched in `./utilities/animals`,  then in `~/tasks/utilities/animals`:

    task-run "utilities/animals"

3. Low level API

You probably don't need to use that explicitly, it's used by the first two methods _internally_, but here is an example of API:

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

