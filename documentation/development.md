# Sparrow6 Development Guide

This document describes how to develop Sparrow6 tasks.

# Tasks

Task in Sparrow represents a script being exectued. A user can write task code on many languages.

To create task simply create `task.*` file in the current directory:

Raku:

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

Now a task could be run either as Raku API:

    task-run ".";
    
Or as command line:

    $ s6 --task-run .

Sparrow supports six languages to write tasks:

* Raku
* Perl 
* Bash
* Python
* Ruby
* Powershell

This table describes `file name -> language` mapping:

    +------------+--------------+
    | Language   | File         |
    +------------+--------------+
    | Raku       | task.pl6     |
    | Perl       | task.pl      |
    | Bash       | task.bash    |
    | Python     | task.py      |
    | Ruby       | task.rb      |
    | Powershell | task.ps1     |
    +------------+--------------+

# Task folders structure

By default task root folder is a current working directory. 

This is where Sparrow looks for a code when execute a task.

However you can organize a folders structure as you wish:

    animals/cow/task.pl6

      say "I make milk";

    animals/cat/task.pl6

      say "I drink milk";

    people/me/task.pl6

      say "I buy milk";

To run task from none default location override task path when call `task-run` function:

     task-run "animals/cow";
     task-run "people/me"; 

Or through command line:

    $ s6 --task-run people/me

# Subtasks

Subtasks are tasks that get called by other tasks. 

You can think subtasks as functions which you _call_ from other tasks.

    hook.pl6

      run_task "system", %( command => "uptime" )

    tasks/system/task.bash

      $(task_var command)

How to create and use subtasks?

* To create a subtask place a task code into _reserved_ `tasks/` folder

For example:

    $ mkdir -p tasks/system
    $ nano tasks/system/task.bash
    
    
* To call subtask one has to create a _hook_ file and use `run_task` within it

For example:

    $ nano hook.pl6
    
* A `run_task` function accepts relative folder within a `tasks/` directory

For example:

    #!raku 
    
    run_task "system", %( command => "uptime" )
    
* A subtask handles input parameters through a `task_var` function

For example:

    #!bash
    
    $(task_var command)
    
   
`run_task` function signatures for Sparrow6 supported languages:

    +------------+----------------------------------------------+
    | Language   | Signature                                    |
    +------------+----------------------------------------------+
    | Raku       | run_task(String,HASH)                        |
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
    | Raku             | task_var(STRING)                               |
    | Perl             | task_var(SCALAR)                               |
    | Python(*)        | task_var(STRING)                               |
    | Ruby             | task_var(STRING)                               |
    | Bash (1-st way)  | $foo                                           |
    | Bash (2-nd way)  | $(task_var foo)                                |
    | Powershell       | task_var(STRING)                               |
    +------------------+------------------------------------------------+

(*) You need to use  `from sparrow6lib import *` to import `task_var` function.

In Bash you can use alternative notation to access subtask parameters:

    tasks/hello-world/task.bash

      echo $he say $hello world

Compare with:

    tasks/hello-world/task.bash

      echo $(task_var he) say $(task_var hello) world

You can call subtask from other subtask using a subtask's hooks. 

# Hooks

* Hooks are scripts that run _before_ a task

* Usually hooks just call subtasks

* But hooks could also do other useful job

* The only difference between task and hook, that hook always runs _before_ task and an output from hook does not appear in STDOUT

This table describes file name -> language mapping for hooks:

    +------------+--------------+
    | Language   | File         |
    +------------+--------------+
    | Raku       | hook.pl6     |
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
    | Raku        | set_stdout(STRING)    |
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
    | Raku        | ignore_error()    |
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
    | Raku        | get_state()       |
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
    | Raku        | update_state(array|hash)    |
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

# RUBYLIB

`$root_dir/lib` path is added to `RUBYLIB` variable. 

# PYTHONPATH

`$root_dir/lib` path is added to `PYTHONPATH` variable. 

# PATH

`$root_dir/bin` path is added to `PATH` variable. 

# Package managers

Sparrow supports following package managers:

* `raku/rakufile`

* `bundler/Gemfile`

* `cpan/cpanfile`

* `pip/requirements.txt` \*

Just place an appropriate file to a `$root_dir` and Sparrow will handle related dependencies 
and install them _locally_, so they are available with task.

(\*) Python3/pip3 is the only supported Python.

Some examples.

An example for `cpanfile`:


    $root_dir/cpanfile

    requires "HTTP::Tiny"

    task.pl

    use HTTP::Tiny;


An example for `rakufile`:

    $root_dir/depends.raku

    App::Mi6 --/test


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

One can override default configuration through an optional `task-run` function HASH parameter:

    task-run "task1", %( 
      main => %(
        foo => 1,
        bar => 2
      )
    );

Or in command line (\*):

    $ s6 --task-run task1@foo=1,bar=2

(\*) command line call does not support nestead Hash like parameters, just plain strings.


# Args stringification

`Args stringification` the process of coercing `args` array into command line parameters.

It allows one to easily create wrappers around existing command line utilities, without
declaring configuration parameters and _reuse_ an _existing_ command line api.

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

    value

The above scenario is implemented by passing `args` List to `task-run` function that run a task:

    task-run "task1", %(
        args => [
          [ 'debug', 'verbose' ],
          %( 'foo' => 'foo_value', 'bar' => 'bar_value' ),
          'value'
        ]
    );
     
Inside Bash task `args` argument is represented as a _string_:

    task.bash

      script $(config args)

So that `script` run with the following command line arguments:

    --debug --verbose --foo foo_value --bar bar_value  value

## `args` coercion semantic

`args` should be an array of _elements_ representing command line arguments

The logic of constructing of command line arguments by an array elements is following:

* For every elements a _rule_ is applied depending on element's type

* `Str/Int` are turned into _value_ parameters: `value ---> value`

* `Array/List` and lists are turned into flags: `(debug, verbose) ---> --debug --verbose`.

* `Hash/Pair` are turned into named parameters: `%( foo => foo_value, bar => bar_value )  ---> --foo foo_value --bar => bar_value`

## Single or double dashes

Double dashes are chosen by default when coercing `args` `Array/List/Hash/Pair` elements into strings.

If one needs single dashes use _explicit_ notation, by adding `-` before a parameter name:

      task-run "task1", %(
        args => [
          [ '-debug', '-verbose' ],
          %( '--foo' => 'foo_value', '-bar' => 'bar_value' ),
          'value'
        ]
      );

Results following command line parameters:

     -debug -verbose --foo foo_value --bar bar_value  value

## Single element `args` array

Because Raku's iteration of nested arrays has none trivial [logic](https://docs.raku.org/language/list#Single_Argument_Rule)
one needs to be cautious when using single element `args` array:

    # Results in `foo bar` command line parameters
    # Iterator will "flatten" args array into [ 'foo', 'bar' ] array

    args => [
      ['foo', 'bar']
    ]

Adding trailing comma to the end of `args` array usually does the trick:

    # Iterator will handle args array as a single element list 
    # With first element ['foo', 'bar']

    args => [
      ['foo', 'bar'],
    ]

# See also

[Sparrow6 plugin manager](https://github.com/melezhik/Sparrow6/blob/master/documentation/s6.md)

# AUTHOR

[Aleksei Melezhik](mailto:melezhik@gmail.com)

# Thanks to

God as the One Who inspires me in my life!

