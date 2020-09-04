# Sparrow6

Sparrow6 is a Raku based automation framework. It's written on Raku and has Raku API.

Who might want to use Sparrow? People dealing with daily tasks varying from servers software installations/configurations to
cloud resources creation. 

Sparrow could be thought as an alternative to existing configuration management
and provisioning tools like Ansible or Chef, however Sparrow is much broader and not limited to configuration
management only. 

It could be seen as a generic automation framework enabling an end user quick and effective script development
easing some typical challenges along the road - such as scripts configurations, code reuse and testing.

#  Sparrow6 Essential Features

* Sparrow is a language friendly framework. A user write underlying code on a language of their choice (see supported languages),
and Sparrow glues all the code using Raku API within high level Sparrow scenarios.

* Sparrow has a command line API. A user can run scripts using command line API, at this point to _use_ Sparrow one does not
need to know any programming language at all.


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

# Supported languages

You can write underlying Sparrow tasks using following languages:

* Raku
* Perl5
* Ruby
* Python
* Bash
* Powershell

All the languages have a _unified_ Sparrow API easing script development, see Sparrow development guide.

# Documentation

## Sparrow Development Guide

Check [documentation/development](https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md) on how to develop Sparrow6 tasks.

## Raku API

Sparrow Raku API allows to run Sparrow tasks as Raku functions. One can use `task-run` function to run arbitrary Sparrow plugins or tasks. Or
choose Sparrow DSL to call a subset of Raku functions designed for most popular automation tasks.

### Task Run

Sparrow provides Raku API to run Sparrow tasks as functions:

    task-run "run my build", "vsts-build", %(
      definition => "JavaApp"
    );

Read more about Sparrow task runner at [documentation/taskrunner](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskrunner.md).

### Sparrow6 DSL

Sparrow6 DSL allows one to run Sparrow tasks using even better Raku functions shortcuts. In comparison with `task-run` function, DSL provides input parameters
validation and dedicated function names. DSL is limited to a certain subset of Sparrow plugins:

    #!raku

    package-install "nginx";

    service-restart "nginx";

    bash "echo Hello World";

See a full list of DSL functions here - [documentation/dsl](https://github.com/melezhik/Sparrow6/blob/master/documentation/dsl.md).

## Plugins

Sparrow plugins are distributable scripts written on Sparrow compatible languages. One can run plugins as Raku functions using Raku API or
as command line utilities.

Check out [documentation/plugins](https://github.com/melezhik/Sparrow6/blob/master/documentation/plugins.md) for details.

## Repositories

Sparrow6 repositories store distributable Sparrow6 tasks packaged as plugins.

See [documentation/repository](https://github.com/melezhik/Sparrow6/blob/master/documentation/repository.md).

### Cli API

Sparrow provides a handy command line interface to run Sparrow tasks as command line.

Enter `s6` - Sparrow command line client and plugin manager.

You use `s6` to install, configure and run tasks as well as uploading tasks to repositories.

Check [documentation/s6](https://github.com/melezhik/Sparrow6/blob/master/documentation/s6.md) for details.

### Sparrow6 modules

Sparrow6 modules allow to write portable Sparrow6 scenarios distributed as Raku modules, 
read more about it - [documentation/modules](https://github.com/melezhik/Sparrow6/blob/master/documentation/modules.md).

## Testing API

Sparrow6 has it's way to write tests for tasks. Choose the one you need.

### Task Checks

Task checks is regexp based DSL to verify structured and unstructured text.

It allows to write _embedded_ tests for user scripts verifying scripts output.

With task checks it's easy to develop scripts in TDD way or create black box testing test suites. See, for example, Tomty framework.

Read more about task checks at [documentation/taskchecks](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskchecks.md).

### M10 

METEN - is a Minimalist Embedded Testing Engine. You can "embed" test into task source code and conditionally run them.

See [documentation/m10](https://github.com/melezhik/Sparrow6/blob/master/documentation/m10.md).


## Environment variables

See [documentation/envvars](https://github.com/melezhik/Sparrow6/blob/master/documentation/envvars.md).

# Sparrow eco system

Sparrow eco system encompasses various tools and subsystems. Choose the one you need. All the tools are powered by Sparrow engine.

## Sparrowdo

Configuration management tool.

Visit [Sparrowdo](https://github.com/melezhik/sparrowdo) GH project for details.

## Tomtit

Task runner and workflow management tool. 

Visit [Tomtit](https://github.com/melezhik/tomtit) GH project for details.

## Tomty

Tomty is Sparrow based test framework. 

Visit [Tomty](https://github.com/melezhik/tomty) GH project for details.

## Sparky

Run Sparrow tasks in asynchronously and remotely.

Visit [Sparky](https://github.com/melezhik/sparky) GH project for details.

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



