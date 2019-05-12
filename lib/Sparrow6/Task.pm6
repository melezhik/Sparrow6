#!perl6

use v6;

unit module Sparrow6::Task;

use Sparrow6::Common::Helpers;
use JSON::Tiny;
use File::Directory::Tree;

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

    run task:
      s6 --task-run plg-name@param1=value2,@param2=value2

    create task:
      s6 --task-add plg-name@task/path

    delete task:
      s6 --task-del task/path

    configure task:
      s6 --task-set task/path

    list tasks:
      s6 --task-list

    options:
      --debug   # enable debug mode


DOC
  }
  

  method task-add ($thing)  {
 
    if $thing ~~ /^^ \s* (\S+) '@'  (\S+) \s* ^^ / {

      my $plugin = "$0"; 

      my $task-path = self!task-path("$1");

      mkdir $task-path;

      self!log("create task dir", $task-path);

      if "{$task-path}/task.json".IO ~~ e {

        self.console("{$task-path}/task.json exists, update plugin information")

      } 

      self!log("task json","{$task-path}/task.json");

      my $fh = open "{$task-path}/task.json", :w;

      $fh.say( to-json( %( plugin => $plugin ) ) );

      $fh.close;

    } else {

      die "usage: task-add plugin\@task/path"

    }

  }

  method task-del ($path)  {

    my $task-path = self!task-path($path);

    empty-directory $task-path;

    self!log("task dir erased", "$task-path");

  }

  method task-set ($path)  {
  
  }

  method task-run ($path) {
  
  }

  method task-list () {
  
    shell("find {self.sparrow-root}/tasks -name task.json -execdir pwd \\;| sed -n 's|^{self.sparrow-root}/tasks/||p'")
  
  }

  method !task-path ($path) {

    return "{self.sparrow-root}/tasks/$path";

  }
}
