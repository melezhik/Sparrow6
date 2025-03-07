#!raku

=begin tomty 
%(
  tag => [ "replace", "soft_check" ]
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "replace-soft-check",
  root  => "examples/tasks",
  task => "replace-soft-check",
  do-test => True,
  show-test-result => True,  
).task-run;

