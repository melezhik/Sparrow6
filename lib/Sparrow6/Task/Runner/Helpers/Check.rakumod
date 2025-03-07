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

      if $tc.results {

        self.console-header("task check");

      }

      for $tc.results -> $r {
        if $r<type> eq "check-expression" {
          #say $r.raku;
          self!check-log(%( 
            message => $r<message>, 
            status => $r<status>, 
            type => "check", 
            :soft-fail($r<soft-fail> || False )
          ));
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

    # revert ignore task check error to default
    $.ignore-task-check-error = False;

  }

}
