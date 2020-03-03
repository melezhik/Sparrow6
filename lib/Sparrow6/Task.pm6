#!perl6

use v6;

unit module Sparrow6::Task;

use Sparrow6::Common::Helpers;
use File::Directory::Tree;
use Sparrow6::DSL;

class Cli

  does Sparrow6::Common::Helpers::Role

{

  has Bool  $.debug;
  has Str   $.name = "rt-cli";
  has Str   $.sparrow-root is rw;
  has Str   $.prefix;

  method TWEAK() {

    self!set-sparrow-root();

  }

  method help () {

    say q:to/DOC/;

    usage:
      s6 $action|$options $thing

    update index:
      s6 --index-update

    list installed plugins:
      s6 --list

    upload plugin:
      s6 --upload

    install plugin:
      s6 --install $plugin
      s6 --install --force $plugin # reinstall, even though if higher version is here

    run plugin:
      s6 --plg-run $plugin@param1=value2,@param2=value2

    run module:
      s6 --module-run $module@param1=value1,param2=value2

    man plugin:
      s6 --plg-man plg-name

    create/update raku task:
      s6 --rt-set task/path

    show raku task:
      s6 --rt-cat task/path

    run raku task:
      s6 --rt-run task/path

    delete raku task:
      s6 --rt-del task/path

    list raku tasks:
      s6 --rt-list

    options:
      --debug   # enable debug mode


DOC
  }

  method find-tasks ($dir, Mu :$test) {
      gather for dir $dir -> $path {
          if $path.basename ~~ $test { my $a = $path.dirname; take $a.subst("{self.sparrow-root}/tasks","",:g).subst("\\",'/', :g)  }
          if $path.d                 { .take for self.find-tasks($path, :$test) };
      }
  }

  method rt-set ($path)  {

    my $rt-path = self!rt-path($path);

    mkdir $rt-path;

    self!log("create task dir", $rt-path);

    if "{$rt-path}/task.pl6".IO ~~ :e {

      self.console("{$rt-path}/task.pl6 exists, update task");

      die "EDITOR env is not set" unless %*ENV<EDITOR>;

      shell("exec {%*ENV<EDITOR>} {$rt-path}/task.pl6");

    }  else {

      self!log("task file","{$rt-path}/task.pl6");

      my $fh = open "{$rt-path}/task.pl6", :w;

      $fh.say("rt-run \"{$path}\", \"plugin-name\", \%(\n);");

      $fh.close;

      die "EDITOR env is not set" unless %*ENV<EDITOR>;

      shell("exec {%*ENV<EDITOR>} {$rt-path}/task.pl6");

    }

  }

  method rt-cat ($path)  {

    my $rt-path = self!rt-path($path);

    if "{$rt-path}/task.pl6".IO ~~ :f {

      self!log("task show", "$rt-path/task.pl6");

      say slurp "{$rt-path}/task.pl6".IO;

    } else {

      die "task $path not found";

    }

  }

  method rt-del ($path)  {

    my $rt-path = self!rt-path($path);

    empty-directory $rt-path;

    self!log("task dir erased", "$rt-path");

    if "{$rt-path}".IO ~~ :d {

      rmdir $rt-path;

      self!log("task dir removesd", "$rt-path");

    }

  }

  method rt-run ($path) {

    my $rt-path = self!rt-path($path);

    EVALFILE "{$rt-path}/task.pl6";

  }


  method rt-list () {

    for self.find-tasks(
      "{self.sparrow-root}/tasks",
      test => /^^ task '.' (ps1||pl||pl6||raku||bash||python||ruby) $$/
    ) -> $t {
        say $t
    }

  }

  method plg-run ($thing)  {

    my ($plg, %params) = self!parse-run-params($thing);

    task-run $plg, $plg, %params;

  }

  method module-run ($thing)  {

    my ($mod, %params) = self!parse-run-params($thing);

    module-run $mod, %params;

  }

  method !rt-path ($path) {

    return "{self.sparrow-root}/tasks/$path";

  }


  method !parse-run-params ( $thing is copy ) {

    my $what;
    my %params = Hash.new();

    if $thing ~~ /\S+/ && $thing ~~ /^^ (<- [ @ ] > ** 1..*) / {

      $what = "$0";

      self.console("run thing $what");

      if $thing ~~ /'@' ( .* )  $$/ {

        %params = "$0".split(",").map({ $_.split("=").flat }).flat;

        self!log("$what params",%params.perl);

      }

    } else {

      die "bad thing - $thing";

    }

    return $what, %params;

  }

}
