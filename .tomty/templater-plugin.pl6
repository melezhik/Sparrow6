#!perl6 

=begin tomty
%(
  tag => "plugin"
)
=end tomty

directory "foo";

task-run "templater-plugin", "templater", %(
  variables => %(
    name => 'Sparrow6',
    language => 'perl6'
  ),
  target  => 'foo/greetings.out',
  mode    => '644',
  source  => slurp 'examples/greetings.tmpl'
);

directory-delete "foo";
