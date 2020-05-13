# Sparrow6

> Sparrow6 - Raku Automation Framework

# Comparison with other tools

* Are you familiar with configuration management tools, and/or automation frameworks like Ansible/Chef/Salt? Sparrow6 is written to solve pretty much the same tasks but with different approach.

* As well as there is task runners like Grunt/Gulp - Sparrow6 could be used as a replacement for them.

# Install

    zef install Sparrow6

# Build Status

[![Build Status](https://travis-ci.org/melezhik/Sparrow6.svg?branch=master)](https://travis-ci.org/melezhik/Sparrow6)

# Roadmap

Sparrow6 is not yet (fully) implemented, see [Roadmap](https://github.com/melezhik/Sparrow6/blob/master/Roadmap.md) for progress.

# Documentation

Sparrow6 consists of various APIs and clients.

It's depends on your needs and purposes which one to use.

Following a brief introduction into each of the Sparrow6 components.

# Sparrow6 Development Guide

Check [documentation/development](https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md) on how to develop Sparrow6 tasks.

# Sparrow6 Task Runner API

Sparrow6 Runner is an internal runner for Sparrow6 tasks:

    task_run "run my build", "vsts-build", %(
      definition => "JavaApp"
    );
  
Read more about task runner at [documentation/taskrunner](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskrunner.md).

# Sparrow6::Task::Repository API

Sparrow6::Task::Repository API is an internal API to interact with Sparrow6 repositories, you probably don't need to
get into it's guts, but if you do, here is briefly outlined API.

Index update

    #!perl6

    use Sparrow6::Task::Repository;

    Sparrow6::Task::Repository::Api.new(
      url => "file:///var/sparrow-local-repo",
      debug => True,
    ).index-update;


Plugin install

    #!perl6

    use Sparrow6::Task::Repository;

    Sparrow6::Task::Repository::Api.new(
      url     => "http://192.168.0.1",
      debug   => True,
    ).plugin-install("foo-test");


# Sparrow6 DSL

Sparrow6 DSL is a syntax sugar to run Sparrow6 tasks, instead of using internal runner you'd
better use this one. This DSL is also exposed through various of clients (Tomtit, Sparrowdo, Sparky, Sparrowform )


    #!perl6

    use Sparrow6::DSL;

    # Run task as plugin
    task-run "my task", "plugin", %(
      foo => "BAR",
      bar => 100
    );

    # Run local task, located at path/to/task directory
    task-run "path/to/task", %(
      foo => "BAR",
      bar => 100
    );

    file "/tmp/foo.txt";
  
    service-restart "nginx";

    bash "echo Hello World";

See the full list of DSL functions here - [documentation/dsl](https://github.com/melezhik/Sparrow6/blob/master/documentation/dsl.md)

# Sparrow6 modules

Sparrow6 modules allow to write portable Sparrow6 scenarios distributed as Perl6 modules, 
read more about it - [documentation/modules](https://github.com/melezhik/Sparrow6/blob/master/documentation/modules.md)

# Embedded testing facilities

Sparrow6 have it's way to write tests for tasks. Choose the one you need.

# Task Checks

Task checks is regexp based DSL to verify structured and unstructured text. 

It allows to write embedded test, verifying tasks output. 

The DSL is extremely flexible and _sometimes_ has quite a steep learning curve, 
but this worth it, once you've got to grips with it,  you'll never want something else! ((=:

Here are some examples:

    # check that output is sequence of English alphabet:

    begin:
      generator: <<CODE
        print join "\n", map {'regexp: ^^' . $_ . '$$'} a .. z;
      CODE
    end:

    #  find all numbers between <number> </number> tags
    #  sum them up
    #  and print sums in sorted order 

    # <number>
    #  10
    #  20
    #  30
    # </number>

    # <number>
    #  20
    #  10
    #  10
    # </number>

    between: {'<number>'}  {'</number>'}
      regexp: (\d+)
    end:


    code: << CODE

      my %sums;
      my $s = 0;  
      for my $stream (@{streams_array()}) {
          $s++;  
          for my $layer (@{$stream}){
            for my $captures @{$layer}) {
              for my $c (@{$captures}){
                $sums{$s} += $c;
              }
            }
          }
      }

      print sort values %sums; 

    CODE

Read more about task checks at [documentation/taskchecks](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskchecks.md).

# M10 

METEN - is a Minimalistic Embedded Testing Engine. You can "embed" test into task source code and conditionally run them.

It's like task check but much simpler, and it's pure Perl6 rather than DSL:

    cat test.pl6

    self.stdout-ok("'foo: {self.task-config<foo>}'");

See [documentation/m10](https://github.com/melezhik/Sparrow6/blob/master/documentation/m10.md).

# Plugins

Sparrow6 plugins are distributable tasks.

See [documentation/plugins](https://github.com/melezhik/Sparrow6/blob/master/documentation/plugins.md).

# Repositories

Sparrow6 repositories store distributable Sparrow6 tasks packaged as plugins.

See [documentation/repository](https://github.com/melezhik/Sparrow6/blob/master/documentation/repository.md).

# Sparrow6::S6

`s6` is a command line client and plugin manager. 

You use `s6` to install, configure and run tasks as well as uploading tasks to repositories.

See [documentation/s6](https://github.com/melezhik/Sparrow6/blob/master/documentation/s6.md).

# Sparrowdo

Configuration management tool.

Visit [Sparrowdo](https://github.com/melezhik/sparrowdo) GH project for details.

# Tomtit

Task runner and workflow management tool. 

Visit [Tomtit](https://github.com/melezhik/tomtit) GH project for details.

# Sparky

Lightweight cron job runner.

Visit [Sparky](https://github.com/melezhik/sparky) GH project for details.

# Sparrowform

Runs Sparrowdo configuration on Terraform instances.

Visit [Sparrowform](https://github.com/melezhik/sparrowform) GH project for details.

# Environment variables

See [documentation/envvars](https://github.com/melezhik/Sparrow6/blob/master/documentation/envvars.md).

# Examples

See `.tomty/` folder.

# Author

Alexey Melezhik

# Thanks to

God as the One Who inspires me in my life!


