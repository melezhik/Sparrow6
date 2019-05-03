run_task('00');
run_task('01', { foo => 'hello world'});
run_task('02', { FOO_THING => 'FOO_VALUE!!!' });

my @s;
my @chk_list;

select(STDERR);

for my $s (Outthentic::Story::Stat->all){
    @s = (
      $s->{path}, 
      ( join ' ', map { "$_: $s->{vars}->{$_}" } keys %{$s->{vars}} ), 
      ( $s->{scenario_status} ? "OK" : "FAILED" ), 
      $s->{stdout}
    );

    for my $c (@{$s->{check_stat}}) {
      push @chk_list, ( $c->{status} ? "ok" : "not ok" ). " - $c->{message}";
    }

  write;

}

format STDERR_TOP = 

/////////////////////
/// Custom Report ///
/////////////////////

.

format STDERR = 
@*
"task: $s[0]"
@*
"variables: $s[1]"
@*
"scenario status: $s[2]"
stdout:
@*
$s[3]

check list:
@* ~~
shift @chk_list
---------------------------------------------------------------------------
.


