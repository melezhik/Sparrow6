my $stat = run_task('01', { foo => 'hello world'});

set_stdout("task status: $stat->{status}");
set_stdout("task path: $stat->{path}");
set_stdout("task vars: $stat->{vars}->{foo}");
set_stdout("check0 status: $stat->{check_stat}->[0]->{status}");
set_stdout("check0 message: $stat->{check_stat}->[0]->{message}");
