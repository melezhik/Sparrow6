#!perl6

use Sparrow6::Task::Runner;

my $s = Sparrow6::Task::Runner::Api.new(
  name  => "bash-update-state",
  root  => "examples/tasks",
  task => "bash-update-state",
  do-test => True,
  show-test-result => True,
).task-run;


say $s<cnt>;

$s<cnt> == 100 or die "s<cnt> should be 100"; 

