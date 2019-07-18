# Sparrow6 Development Guide

This document describes how to develop Sparrow6 tasks. 

# Tasks

Task is a main unit of operations. One can think task as a script or scenario.

To create task simply create `task.*` file in the current directory:

Perl6:

    task.pl6

      say "What is your name?";
      say "Rakudo!";

Perl:

    task.pl

      print "What is your name?\n";
      print "Camel!\n";

Bash:

    task.bash

      echo "What is your name?"
      echo "Bash!"

Python:

    task.py

      print "What is your name?"
      print "Python!"

Ruby:

    task.rb

      puts "What is your name?"
      puts "Ruby"

Powershell:

    task.ps1

      Write-Host "What is your name?"
      Write-Host "Powershell"


Sparrow6 supports six languages:

* Perl6
* Perl 
* Bash
* Python
* Ruby
* Powershell

This table describes `file name -> language` mapping:

    +------------+--------------+
    | Language   | File         |
    +------------+--------------+
    | Perl6      | task.pl6     |
    | Perl       | task.pl      |
    | Bash       | task.bash    |
    | Python     | task.py      |
    | Ruby       | task.rb      |
    | Powershell | task.ps1     |
    +------------+--------------+

# Task folders structure

By default task root location is current working directory:

    use Sparrow6::Task::Runner;

    Sparrow6::Task::Runner::Api.new(
      name  => "my task"
    ).task-run;



However you can organize the folders structure as you wish:

    tasks/cow/task.pl6

      say "I make milk";

    tasks/cat/task.pl6

      say "I drink milk";

    tasks/me/task.pl6

      say "I buy milk";

One run none default task by passing `task` parameter to constructor:

    #!perl6

    use Sparrow6::Task::Runner;

    Sparrow6::Task::Runner::Api.new(
      task  => "tasks/cow"
      name  => "cow task"
    ).task-run;
    
You can also pass `root` parameter to set task root directory:

    Sparrow6::Task::Runner::Api.new(
      root  => "/var/data/tasks"
      task  => "cow"
      name  => "cow task"
    ).task-run;


# Subtasks

Subtasks are tasks that get called by other tasks. You can think sub tasks as functions:


    hook.pl6

      run_task "execute", %( command => "uptime" )

    tasks/execute/task.bash

      $(task_var command)

* One define sub tasks at _reserved_ folder named `tasks`.
* To call subtask from other task one defines _hook_ file.
* `subtask function` accepts relative task folder ( without `tasks/` chunk )
* Subtask handles input parameters through `task_var` function

`run_task` function signatures for Sparrow6 supported languages:

    +------------+----------------------------------------------+
    | Language   | Signature                                    |
    +------------+----------------------------------------------+
    | Perl6      | run_task(String,HASH)                        |
    | Perl       | run_task(SCALAR,HASHREF)                     |
    | Bash       | run_task TASK_NANE NAME VAL NAME2 VAL2       |
    | Python(*)  | run_task(STRING,DICT)                        |
    | Ruby       | run_task(STRING,HASH)                        |
    | Powershell | run_task(STRING,HASH)                        |
    +------------+----------------------------------------------+

(*) You need to use `from sparrow6lib import *` to import `run_task` function.

`task_var` function signatures for Sparrow6 supported languages:

    +------------------+------------------------------------------------+
    | Language         | Signature                                      |
    +------------------+------------------------------------------------+
    | Perl6            | task_var(STRING)                               |
    | Perl             | task_var(SCALAR)                               |
    | Python(*)        | task_var(STRING)                               |
    | Ruby             | task_var(STRING)                               |
    | Bash (1-st way)  | $foo                                           |
    | Bash (2-nd way)  | $(task_var foo)                                |
    | Powershell       | task_var(STRING)                               |
    +------------------+------------------------------------------------+

(*) You need to use  `from sparrow6lib import *` to import `task_var` function.

In Bash you can use alternative notation to access sub task parameters:

    tasks/hello-world/task.bash

      echo $he say $hello world

Compare with:

    tasks/hello-world/task.bash

      echo $(task_var he) say $(task_var hello) world

One can call subtask from other sub task and so on.

# Hooks

* Hooks are scripts that run _before_ task, _usually_ hooks call sub tasks,
and do some other useful job. 

* The only difference between task and hook, that hook always runs _before_ task 
and output from hook does not appear in STDOUT.


This table describes file name -> language mapping for hooks:

    +------------+--------------+
    | Language   | File         |
    +------------+--------------+
    | Perl6      | hook.pl6     |
    | Perl       | hook.pl      |
    | Bash       | hook.bash    |
    | Python     | hook.py      |
    | Ruby       | hook.rb      |
    | Powershell | hook.ps1     |
    +------------+--------------+

# Set hook output

If one need to generate output from hook use `set_stdout` function:

    hook.bash

      set_stdout "Hello from hook"

If hook has output, the _related_ task is executed and task output get merged with what produced by set_stdout:

    hook.pl6

      if config<mood> eq "sleepy" {  
        set_stdout("Black Coffee")
      }

    task.pl6

      say "Sandwich"

    run

      Sparrow6::Task::Runner::Api.new(
        name  => "make an order",
        parameters => %( mood => "sleepy" )
      ).task-run;

    output

      BlackCoffee
      Sandwich

`set_stdout` function signatures for Sparrow6 supported languages:

    +-------------+-----------------------+
    | Language    | signature             |
    +-------------+-----------------------+
    | Perl6       | set_stdout(STRING)    |
    | Perl        | set_stdout(SCALAR)    |
    | Bash        | set_stdout(STRING)    |
    | Python(*)   | set_stdout(STRING)    |
    | Ruby        | set_stdout(STRING)    |
    | Powershell  | set_stdout(STRING)    |
    +-------------+-----------------------+

(*) You need to `from sparrow6lib import *` to import set_stdout function.


It's ok to have a hook without having related task, in this case it's just hook that is executed.

# Helper functions

Here is the list of function one can use _inside tasks and hooks_:

* `root_dir()` - task root directory.

* `cache_root_dir()` - cache root directory, every task has a cache directory served for it's purposes

* `cache_dir()` - task cache directory, every task has a cache directory served for it's purposes

* `task_dir()` - task directory relative to `root_dir()`

* `config()` - task configuration object.

* `os()` - mnemonic name of underlying operation system.

- You need to use `from sparrow6lib import *` in Python to import helpers functions.

- In Bash these functions are represented by variables, e.g. $root_dir, $os, so on.

# Recognizable OS list

* alpine
* amazon
* archlinux
* centos5
* centos6
* centos7
* debian
* fedora
* minoca
* ubuntu
* funtoo
* darwin
* windows

# Task descriptions

Task description is just a plain text file with useful description of a task.

Task description is printed out when task is executed.

    task.txt

      This task do this or that

# Ignore task failures

If task fails ( the exit code is not equal to zero ), task runner stops and raises exception. 

To continue others tasks execution use `ignore_error` function inside hook:

    hook.pl

      ignore_error();

`ignore_error` function signatures for Sparrow6 supported languages:

    +-------------+-------------------+
    | Language    | signature         |
    +-------------+-------------------+
    | Perl6       | ignore_error()    |
    | Perl        | ignore_error()    |
    | Bash        | ignore_error      |
    | Python(*)   | ignore_error()    |
    | Ruby        | ignore_error()    |
    | Powershell  | ignore_error()    |
    +-------------+-------------------+

# Task states

Task state is a piece of data that is shared across tasks and returned when task's finished:

    my %state = task-run "my-task", "task";

    say %state<foo>;

    say %state<bar>;

This feature allows to write tasks like function and run tasks in pipelines style, where

the next task gets input parameters resulted from previous task.

Any task or hook get an access to task data through a couple of functions:

* `get_state`

Return current task state. The return object is Hash.

* `update_state(hash)`

Update current task state. The input parameter should be Hash.

Here is en example for task written on Perl:


    task.pl

    update_state({ foo => config<foo>})

    task "foo"

    tasks/foo/task.pl

    my $foo = get_state()->{foo};

    $foo++;

    update_state({ foo => $foo });

And this is how task state is returned from task and used in "pipeline":

    my %state = task-run "set foo", "set-foo", %( foo => 100 );

    task-run "set foo", "set-foo";

    %state = task-run "set foo", "set-foo", %( foo => %state<foo> );

    say %state<foo>; # 101

`get_state` function signatures for Sparrow6 supported languages:

    +-------------+-------------------+
    | Language    | signature         |
    +-------------+-------------------+
    | Perl6       | get_state()       |
    | Perl        | get_state()       |
    | Bash        | not supported     |
    | Python(*)   | get_state()       |
    | Ruby        | get_state()       |
    | Powershell  | get_state()       |
    +-------------+-------------------+

`update_state` function signatures for Sparrow6 supported languages:

    +-------------+-----------------------------+
    | Language    | signature                   |
    +-------------+-----------------------------+
    | Perl6       | update_state(array|hash)    |
    | Perl        | update_state(array|hash)    |
    | Bash        | not supported               |
    | Python(*)   | update_state(array|hash)    |
    | Ruby        | update_state(array|hash)    |
    | Powershell  | update_state(array|hash)    |
    +-------------+-----------------------------+

# Language libraries

One can share some language specific libraries across tasks:

Bash:

    common.bash

      function helper1 {
        # some code here
      } 

    task.bash

        helper1

Ruby:

    common.rb

      def helper1
        # some code here
      end

      def helper2
        # some code here
      end

    hook.rb

      helper1();

    task.rb

      helper2();

This table describes `file name -> language` mapping for libraries:

    +-----------+-----------------+------------------------+
    | Language  | file            | locations              |
    +-----------+-----------------+------------------------+
    | Bash      | common.bash     | $root_dir/common.bash  |
    |           |                 | $task_dir/common.bash  |
    +-----------+-----------------+------------------------+
    | Ruby      | common.rb       | $root_dir/common.rb    |
    |           |                 | $task_dir/common.bash  |
    +-----------+-----------------+------------------------+

# PERL5LIB

`$root_dir/lib` path is added to `$PERL5LIB` variable. 

This make it easy to place custom Perl modules under task root directory:

    lib/Foo/Bar/Baz.pm

      package Foo::Bar::Baz;

      1;

    task.pl

      use Foo::Bar::Baz;

# Task configuration

To define configuration available across tasks and hook create `config.yaml` in the root directory:

    config.yaml

    main :
      foo : 1
      bar : 2


Configuration data is accessible via `config` function:

      my $foo = config()->{main}->{foo};
      my $bar = config()->{main}->{bar};

Examples for other languages:

Bash:

      foo=$(config main.foo )
      bar=$(config main.bar )

Python:

      from sparrow6lib import *

      foo = config()['main']['foo']
      bar = config()['main']['bar']


Ruby:

      foo = config['main']['foo']
      bar = config['main']['bar']

Powershell:

      $config = config 'main'
      $foo = $config.foo
      $bar = $config.bar


Overriding configuration

One can override default configuration through constructor:


    Sparrow6::Task::Runner::Api.new(
      name  => "my task",
      parameters => %( 
        main => %(
          foo => 1,
          bar => 2
        )
      )  
    ).task-run;


# Args stringification

`Arg stringification` the process of coercing `args` array into command line parameters.

Consider a simple example.

We want to create a wrapper for some external `script` which accepts the following command line arguments:

    script {flags} {named parameters} {value}

Where

Flags are:

    --verbose
    --debug

Named parameters are:

    --foo foo-_value
    --var bar_value

And value is just a string:

    parameter

The above scenario implemented by passing `args` array into `Sparrow6::Task::Runner::Api`
constructor:

    Sparrow6::Task::Runner::Api.new(
      name  => "my task",
      parameters => %(
        args => [
          [ 'debug', 'verbose' ],
          %( 'foo' => 'foo_value', 'bar' => 'bar_value' ),
          'parameter'
        ]
      )
    ).task-run;

Inside Bash task `args` argument is represented as a _string_:

    task.bash

      script $(config args)

So that `script` run with the following command line arguments:

    --debug --verbose --foo foo_value --bar bar_value  parameter

## `args` semantic

* `args` should be an array which elements are processed in order
* for every elements rules are applied depending on element's type
* Scalars are turned into scalars: `parameter ---> parameter`
* Arrays are turned into scalars started with double dashes: `(debug, verbose) ---> --debug --verbose`.
* Hashes are turned into named parameters: `%( foo => foo_value, bar => bar_value )  ---> --foo foo_value --bar => bar_value`

## Single or double dashes

Double dashes is default behavior when coercing `args` array into string.

If you need single dashes use _explicit_ notation:

    Sparrow6::Task::Runner::Api.new(
      name  => "my task",
      parameters => %(
        args => [
          [ '-debug', '-verbose' ],
          %( '--foo' => 'foo_value', '-bar' => 'bar_value' ),
          'parameter'
        ]
      )
    ).task-run;

Results in args stringified as:

    -debug -verbose --foo foo_value --bar bar_value  parameter

# See also

[Sparrow6 plugin manager](https://github.com/melezhik/Sparrow6/blob/master/documentation/s6.md)

# AUTHOR

[Aleksei Melezhik](mailto:melezhik@gmail.com)

# Thanks to

God as the One Who inspires me in my life!

