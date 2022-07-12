#!perl6

=begin tomty
%(
  tag => ( "windows", "internet" )
)
=end tomty

if %*ENV<SKIP_POWERSHELL> {
  say "this test is skipped, due to SKIP_POWERSHELL is enabled";
  exit(0);
}

use Sparrow6::DSL;

task-run "examples/tasks/powershell@web-request";
