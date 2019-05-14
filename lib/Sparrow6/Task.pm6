#!perl6

use v6;

unit module Sparrow6::Task;

use Sparrow6::Common::Helpers;
use File::Directory::Tree;
use Sparrow6::DSL;

class Cli

  does Sparrow6::Common::Helpers::Role

{

  has Bool  $.debug = %*ENV<SP6_DEBUG> ?? True !! False ;
  has Str   $.name = "task-cli";
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
      s6 --plg-run plg-name@param1=value2,@param2=value2

    create/update task:
      s6 --task-set task/path

    show task:
      s6 --task-show task/path

    run task:
      s6 --task-run task/path

    delete task:
      s6 --task-del task/path

    list tasks:
      s6 --task-list

    options:
      --debug   # enable debug mode


DOC
  }
  

  method task-set ($path)  {
 
    my $task-path = self!task-path($path);

    mkdir $task-path;

    self!log("create task dir", $task-path);

    if "{$task-path}/task.pl6".IO ~~ :e {

      self.console("{$task-path}/task.pl6 exists, update task");

      die "EDITOR env is not set" unless %*ENV<EDITOR>;

      shell("exec {%*ENV<EDITOR>} {$task-path}/task.pl6");

    }  else {

      self!log("task file","{$task-path}/task.pl6");

      my $fh = open "{$task-path}/task.pl6", :w;

      $fh.say("task-run \"{$path}\", \"plugin-name\", \%(\n);");

      $fh.close;

      die "EDITOR env is not set" unless %*ENV<EDITOR>;

      shell("exec {%*ENV<EDITOR>} {$task-path}/task.pl6");

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

    EVALFILE "{$task-path}/task.pl6";

  }

  method task-show ($path) {

    my $task-path = self!task-path($path);

    say slurp "{$task-path}/task.pl6";

  }

  method task-list () {

    shell("find {self.sparrow-root}/tasks -name task.pl6 -execdir pwd \\;| sed -n 's|^{self.sparrow-root}/tasks/||p'")

  }

  method !task-path ($path) {

    return "{self.sparrow-root}/tasks/$path";

  }
}
