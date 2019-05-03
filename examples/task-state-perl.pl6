#!perl6 

use Sparrow6::Task::Runner;

my %state = Sparrow6::Task::Runner::Api.new(
  name  => "task-state-perl",
  root  => "examples/tasks",
  task => "task-state-perl",
  do-test => True,
  show-test-result => True,
).task-run;

say %state.perl;
