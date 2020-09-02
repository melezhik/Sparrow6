# Sparrow6

Sparrow6 is a Raku based automation framework. It's written on Raku and has a Raku API.

Who might want to use Sparrow? People dealing with daily tasks varying from servers software installation/configuration to
cloud resources creation. Sparrow could be thought as an alternative to existing configuration management
and provisioning tools like Ansible or Chef, however Sparrow is much broader and not limited to configuration
management only. It could be seen as generic automation framework enabling a user quick and effective scripts development
easing some typical challenges along the road - such as scripts configurations, code reuse and testing.

#  Sparrow6 essential features

* Sparrow is a language friendly framework. A user write underlying code on language of their choice (see supported languages),
and Sparrow glues all the code using Raku API within high level Sparrow scenarios.

* Sparrow has a command line API. A user can run scripts using command line API, at this point to _use_ Sparrow one does not
need to know any programming langauge at all.


* Sparrow is a script oriented framework. Basic low level building blocks in Sparrow are old good scripts.
That makes Sparrow extremely effective when working with existing codebase written on many well known languages.

* Sparrow is a function oriented framework. Though users write underlying code as scripts, those scripts are called as
Raku functions with high level scenarios.

* Sparrow has a repository of ready to use scripts or Sparrow plugins as they called in Sparrow. No need to code at all,
just find a proper plugin and start using it. Sparrow repository could be easily deployed as public or private instances
using just an Nginx web server.


# Install

    zef install Sparrow6

# Build Status

[![Build Status](https://travis-ci.org/melezhik/Sparrow6.svg?branch=master)](https://travis-ci.org/melezhik/Sparrow6)

# Documentation

Sparrow6 consists of various APIs and clients.

It's depends on your needs and purposes which one to use.

Following a brief introduction into each of the Sparrow6 components.

# Sparrow6 Development Guide

Check [documentation/development](https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md) on how to develop Sparrow6 tasks.

# Sparrow6 Task Runner API

Sparrow6 Runner is a runner for Sparrow6 tasks. This is how an end user runs most of the Sparrow plugins:

    task-run "run my build", "vsts-build", %(
      definition => "JavaApp"
    );

Read more about task runner at [documentation/taskrunner](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskrunner.md).

# Sparrow6 DSL

Sparrow6 DSL allows one to run some _predefined_ Sparrow plugins, using Raku functions shortcuts.

All those plugins are already shipped with Sparrow repository, so you can start use them right away.

    #!raku

    package-install "nginx";

    service-restart "nginx";

    bash "echo Hello World";

See the full list of DSL functions here - [documentation/dsl](https://github.com/melezhik/Sparrow6/blob/master/documentation/dsl.md)

# Sparrow6 modules

Sparrow6 modules allow to write portable Sparrow6 scenarios distributed as Raku modules, 
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

Run Sparrow tasks in asynchronously and remotely.

Visit [Sparky](https://github.com/melezhik/sparky) GH project for details.

# Sparrowform

Runs Sparrowdo configuration on Terraform instances.

Visit [Sparrowform](https://github.com/melezhik/sparrowform) GH project for details.

# Environment variables

See [documentation/envvars](https://github.com/melezhik/Sparrow6/blob/master/documentation/envvars.md).

# Internal APIs

This section contains links to some internal APIs, which are mostly of interest for Sparrow developers:

* Sparrow6::Task::Repository API - [documentation/internal/repo-and-plugins-api](https://github.com/melezhik/Sparrow6/blob/master/documentation/internal/repo-and-plugins-api.md)

# Roadmap

Sparrow6 is not yet (fully) implemented, see [Roadmap](https://github.com/melezhik/Sparrow6/blob/master/Roadmap.md) for progress.

# Examples

See `.tomty/` folder.

# Author

Alexey Melezhik

# Thanks to

God as the One Who inspires me in my life!



