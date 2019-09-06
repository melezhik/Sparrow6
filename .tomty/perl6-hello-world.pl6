#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl6-hello-world",
  root  => "examples/tasks",
  task => "perl6-hello-world",
  do-test => True,
  show-test-result => True,
  parameters => %(
    language => "Perl6"
  )
).task-run;

