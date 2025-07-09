#!raku

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "sources",
  root  => "examples/tasks/sources/",
  task => "",
  do-test => True,
  show-test-result => True,
).task-run;
