#!perl6

=begin tomty
%(
  tag => "windows"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl6-ignore-task-err",
  root  => "examples/tasks",
  task => "perl6-ignore-task-err",
  do-test => True,
  show-test-result => True,
).task-run;
