unit module Sparrow6::Task::Runner::Helpers::Check;
use Sparrow6::Task::Check;

role Role {

  method !run-task-check ($root) {

    if  "$root/task.check".IO ~~ :e {

      self!log("execute task check","$root/task.check");

      my $tc = Sparrow6::Task::Check::Api.new(
        cache-root-dir => self.cache-root-dir,
        parent-task-root-dir => $root,
        tr => self.clone,
        data => self.stdout-data,
      );

      $tc.validate("$root/task.check".IO.lines);

      for $tc.results -> $r {
        if $r<type> eq "check-expression" {
          self!check-log(%( message => $r<message>, status => $r<status>, type => "check" ));
          $.check-pass = False unless $r<status>;
        } elsif $r<type> eq "note" {
          self!check-log(%( message => $r<message>, type => "note" ));
        }

      }

    }

  }

}
