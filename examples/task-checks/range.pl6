#!perl6

use Sparrow6::Task::Check;
use File::Directory::Tree;

my $data = q:to/END/; 
  ===
  a
  b
  c
  d
  e
  f
  ===
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

  between: {"==="} {"==="}
    a
    b
    c
    d
    e
    f
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
