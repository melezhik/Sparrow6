#!raku

=begin tomty 
%(
  tag => [ "should-fail" ]
)
=end tomty 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "sysctl-hardeining",
  root  => "examples/tasks/sysctl/hardeining",
  task => "",
  do-test => True,
  show-test-result => True,  
).task-run;

