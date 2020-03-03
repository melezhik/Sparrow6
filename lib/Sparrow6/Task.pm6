#!perl6

use v6;

unit module Sparrow6::Task;

use Sparrow6::Common::Helpers;
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

  method plg-run ($thing)  {

    my ($plg, %params) = self!parse-run-params($thing);

    task-run $plg, $plg, %params;

  }

  method module-run ($thing)  {

    my ($mod, %params) = self!parse-run-params($thing);

    module-run $mod, %params;

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
