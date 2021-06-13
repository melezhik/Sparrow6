use Colorizable;

my $planet = "Sparrow" but Colorizable;

say $planet.colorize(:fg(blue), :bg(red), :mo(bold));
say $planet.colorize(:fg(blue), :bg(green), :mo(italic));
say $planet.colorize(:fg(green));
say $planet.colorize(:fg(green), :mo(bold));
say $planet.colorize(:fg(green), :mo(italic));
say $planet.colorize(:fg(red), :mo(italic));
say $planet.colorize(:fg(cyan), :mo(italic));
say $planet.colorize(:fg(yellow), :mo(italic));
