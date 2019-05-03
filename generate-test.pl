my $story = $_;
chomp $story;

#print "echo {{$story}} ...\n";

s{examples/migration/powershell/}[] for $story;


print <<"HERE";

echo '#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "$story",
  root  => "examples/tasks/",
  story => "powershell/$story",
  do-test => True,
  show-test-result => True,
).task-run;' > examples/powershell-$story.pl6

mv examples/migration/powershell/$story examples/tasks/powershell

HERE

BEGIN {

print "set -e\n";

}
