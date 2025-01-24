my $ext = prompt("ext (rakumod): ");

$ext = "rakumod" unless $ext;

my $search1 = prompt("search1: ");

my $search2 = prompt("search2: ");

my $exclude = prompt("exclude: ");

say "find [$search1] [$search2] !$exclude in $ext";

task-run "find $search1 $search2 in $ext", "find", %(
  :$ext,
  :$search1,
  search2 => $search2 || "",
  exclude => $exclude || "",
);

