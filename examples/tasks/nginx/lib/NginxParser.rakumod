unit module NginxParser;

sub gene () is export {

  say "note: start nginx parser ...";
  
  say q<regexp: server \\s* \{>;

  say q:to /CODE/;
code: <<OK
!raku
  for captures-full()<> -> $i {
    say "found server block at index: ", $i<index>;
  };
OK
CODE

}