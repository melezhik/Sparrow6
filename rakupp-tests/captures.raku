my $pattern = 'A (\S+) A';

my $matched = "ABCDCBA".comb(/<mymatch=$pattern>/,:match)>>.<mymatch>; 


my @a = $matched>>.Slip>>.Str; 


say @a.raku
