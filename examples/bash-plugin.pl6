#!perl6 

use Sparrow6::DSL;

task-run "bash plugin", "bash", %(
  command => 'echo $foo',
  debug   => 1,
  envvars => %(
    foo => "BAR"
  ),
  expect_stdout => "BAR"
);

