our @foo = ('OK');

run_task('foo');

run_task('bar', { VAR => 'hello bar!' } );


#diag explain @Outthentic::DSL::CHECK_LIST;
