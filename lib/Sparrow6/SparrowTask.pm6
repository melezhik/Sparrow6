#!perl6

use v6;

unit module Sparrow6::SparrowTask;

use Sparrow6::Common::Helpers;

class Cli

  does Sparrow6::Common::Helpers::Role

{

  has Bool  $.debug;
  has Str   $.name = "sparrowtask";
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

  method task-cat ($path)  {

    if "{$path}/task.pl6".IO ~~ :f {

      self!log("task show", "$path/task.pl6");

      say slurp "{$path}/task.pl6".IO;

    } elsif "{$path}/task.bash".IO ~~ :f {

      self!log("task show", "$path/task.bash");

      say slurp "{$path}/task.bash".IO;

    } elsif "{$path}/task.py".IO ~~ :f {

      self!log("task show", "$path/task.py");

      say slurp "{$path}/task.py".IO;

    } elsif "{$path}/task.pl".IO ~~ :f {

      self!log("task show", "$path/task.pl");

      say slurp "{$path}/task.pl".IO;

    } elsif "{$path}/task.rb".IO ~~ :f {

      self!log("task show", "$path/task.rb");

      say slurp "{$path}/task.rb".IO;

    } elsif "{$path}/task.ps1".IO ~~ :f {

      self!log("task show", "$path/task.ps1");

      say slurp "{$path}/task.ps1".IO;

    } else {

      die "task $path not found";

    }

  }


  method task-list () {

    for self.find-tasks(
      ".",
      test => /^^ task '.' (ps1||pl||pl6||raku||bash||python||ruby) $$/
    ) -> $t {
        say $t
    }

  }


}
