#!perl6 

=begin tomty
%(
  tag => "windows"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl6-read-config",
  root  => "examples/tasks",
  task => "perl6-read-config",
  do-test => True,
  show-test-result => True,  
).task-run;

