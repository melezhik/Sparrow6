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
  name  => "config",
  root  => "examples/tasks/",
  task => "powershell/config",
  do-test => True,
  show-test-result => True,
).task-run;
