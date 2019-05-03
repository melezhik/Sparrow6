#!perl6

use Sparrow6::Task::Check;
use File::Directory::Tree;

my $data = q:to/END/; 
    that string followed by
    this string followed by
    another one string
    with that string
    at the very end.
END

my $cache-dir = "/tmp/.task-check/" ~ 5.rand.Int.Str;

if $cache-dir.IO ~~ :e {
  empty-directory $cache-dir;
  say "cache dir $cache-dir removed";
}

mkdir $cache-dir;

my $tc = Sparrow6::Task::Check::Api.new(
  cache-root-dir => $cache-dir,
  data => $data.lines.Array,
);

my $check = q:to/END/;

  # this text block
  # consists of 5 strings
  # going consecutive

  begin:
      # plain strings
      this string followed by
      that string followed by
      another one
      # regexps patterns:
      regexp: with\s+(this|that)
      # and the last one in a block
      at the very end
  end:

END

$tc.validate($check.lines);

my $check-pass = True;

for $tc.results -> $r {
  if $r<type> eq "check-expression" {
    say "{$r<message>} {$r<status>}";
    $check-pass = False unless $r<status>;
  }
}

#exit(2) unless $check-pass;
