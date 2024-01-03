unit module sparrow6common;

use JSON::Fast;

sub json-var() is export {

  my $path = @*ARGS[0];
  my $name = @*ARGS[1];

  my $data = slurp($path);

  my $conf = from-json($data); 

  for $name.split(".") -> $n {
    $conf = %$conf{$n};
  }


  if ( $conf.^name eq "List" or $conf.^name eq "Array" ) { 

    my $c =  join ' ', @$conf ;

    print '(' ~ $c ~ ')';

  } else {

    print $conf.defined ?? $conf !! "";

  }

}


