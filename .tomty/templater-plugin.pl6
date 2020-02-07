#!perl6 

use Sparrow6::DSL;

task-run "templater-plugin", "templater", %(
  variables => %(
    name => 'Sparrow6',
    language => 'perl6'
  ),
  target  => 'greetings.out',
  mode    => '644',
  source  => slurp 'examples/greetings.tmpl'
);

