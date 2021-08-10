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
          if ! $r<status> {
            if ! $.ignore-task-check-error {
              self!log("mark check-pass as False",$root);
              $.check-pass = False;
            }
            $.task-check-err-cnt++;
            self!log("bump task-check-err-cnt",$.task-check-err-cnt);
          }
        } elsif $r<type> eq "note" {
          self!check-log(%( message => $r<message>, type => "note" ));
        }

      }

    }

  }

}
