#!raku

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "any_with_streams_as_array",
  root  => "examples/tasks",
  task => "any_with_streams_as_array",
  do-test => True,
  show-test-result => True,
).task-run;
