#!raku

=begin tomty 
%(
  tag => [ "negation" ]
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "negations-02",
  root  => "examples/tasks/negations",
  task => "02",
  do-test => True,
  show-test-result => True,  
).task-run;

