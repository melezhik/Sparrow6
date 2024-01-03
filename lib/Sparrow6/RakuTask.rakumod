#!raku

use v6;

unit module Sparrow6::RakuTask;

use Sparrow6::Common::Helpers;
use File::Directory::Tree;
use Sparrow6::DSL;

class Cli

  does Sparrow6::Common::Helpers::Role

{

  has Bool  $.debug;
  has Str   $.name = "task";
  has Str   $.sparrow-root is rw;
  has Str   $.prefix;

  method TWEAK() {

    self!set-sparrow-root();

  }

  method find-tasks ($dir, Mu :$test) {
      gather for dir $dir -> $path {
          if $path.basename ~~ $test { my $a = $path.dirname; take $a.subst("\\",'/', :g)  }
          if $path.d                 { .take for self.find-tasks($path, :$test) };
      }
  }

  method task-set ($path)  {

    my $task-path = self!task-path($path);

    mkdir $task-path;

    self!log("create task dir", $task-path);

    if "{$task-path}/task.raku".IO ~~ :e {
      
      self.console-with-prefix("{$task-path}/task.raku exists, update task");

      die "EDITOR env is not set" unless %*ENV<EDITOR>;

      shell("exec {%*ENV<EDITOR>} {$task-path}/task.raku");

    }  else {

      self!log("task file","{$task-path}/task.raku");

      my $fh = open "{$task-path}/task.raku", :w;

      $fh.say("task-run \"{$path}\", \"plugin-name\", \%(\n);");

      $fh.close;

      die "EDITOR env is not set" unless %*ENV<EDITOR>;

      shell("exec {%*ENV<EDITOR>} {$task-path}/task.raku");

    }

  }

  method task-cat ($path)  {

    my $task-path = self!task-path($path);

    if "{$task-path}/task.raku".IO ~~ :f {

      self!log("task show", "$task-path/task.raku");

      say slurp "{$task-path}/task.raku".IO;

    } else {

      die "task $path not found";

    }

  }

  method task-del ($path)  {

    my $task-path = self!task-path($path);

    empty-directory $task-path;

    self!log("task dir erased", "$task-path");

    if "{$task-path}".IO ~~ :d {

      rmdir $task-path;

      self!log("task dir removesd", "$task-path");

    }

  }

  method task-run ($path) {

    my $task-path = self!task-path($path);

    EVALFILE "{$task-path}/task.raku";

  }


  method task-list () {

    my $cd = $*CWD;

    chdir "{self.sparrow-root}/tasks";

    my $i = 0;

    for self.find-tasks(
      ".",
      test => /^^ task '.' (ps1||pl|||raku||bash||python||ruby) $$/
    ) -> $t {
        $i++;
        say $t
    }

    chdir $cd;

    say "===";
    say "[$i] raku tasks found";

  }

  method !task-path ($path) {

    return "{self.sparrow-root}/tasks/$path";

  }


}
