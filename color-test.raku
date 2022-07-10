use Terminal::ANSIColor;

my $planet = "Sparrow";

say $planet.&colored('bold blue on_red');
say $planet.&colored('italic blue on_green');
say $planet.&colored('green');
say $planet.&colored('bold green');
say $planet.&colored('italic green');
say $planet.&colored('italic red');
say $planet.&colored('italic cyan');
say $planet.&colored('italic yellow');
