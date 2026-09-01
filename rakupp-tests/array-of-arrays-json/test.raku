use JSON::Fast;

my $array = from-json slurp "data.json";

my @arr = [];

for $array<> -> $g {
    my @g;
    for $g<> -> $l {
      push @g, $l<>;
    }
    push @arr, @g;
}


say @arr.raku;

