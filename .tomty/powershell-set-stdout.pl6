#!perl6

=begin tomty
%(
  tag => "windows"
)
=end tomty

if %*ENV<SKIP_POWERSHELL> {
  say "this test is skipped, due to SKIP_POWERSHELL is enabled";
  exit(0);
}

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "set-stdout",
  root  => "examples/tasks/",
  task => "powershell/set-stdout",
  do-test => True,
  show-test-result => True,
).task-run;
