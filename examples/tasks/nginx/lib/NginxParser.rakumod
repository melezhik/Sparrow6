unit module NginxParser;

sub gene () is export {

  say "note: start nginx parser ...";
  
  say q<regexp: server \\s* \{>;

  say q:to /CODE/;
generator: <<OK
!raku
  use NginxParser;
  update_state({});
  for captures-full()<> -> $i {
    say "note: found server block at index: ", $i<index>;
    say "begin:";
    say ":{$i<index>}:";
    my $s = get_state();
    $s<nginx><servers>{$i<index>}<stack> = 1;
    $s<nginx><servers>{$i<index>}<meta> = {};
    update_state($s);
    parse-server($i<index>);
    say "end:";
  };
OK
CODE

}


sub parse-server (int $ind) is export {
  
  say ":any:";
  
  say q:to /CODE/.subst("%ind%",$ind,:g);
generator: <<OK
!raku
  use NginxParser;
  my $line = captures-full()[0];
  #say "note: parse-server [%ind%] line: $line<index> data: {$line<data>.subst('#','//')}";
  my $stack = get_state()<nginx><servers>{%ind%}<stack>;
  my $s_full = get_state();
  my $data = $line<data>;
  #say "note: current stack: ", $s_full.perl;
  if $data ~~ /\}/ {
    $stack--;
    $s_full<nginx><servers>{%ind%}<stack> = $stack;
    update_state($s_full);
    if $stack == 0 {
      say "note: end, index ", $line<index>;
    } else {
      say "generator: <<RAKU";
      say "!raku";
      say "use NginxParser;";
      say 'parse-server(%ind%);';
      say "RAKU";
    }
  } elsif $data ~~ /\{/ {
    $stack++;  
    $s_full<nginx><servers>{%ind%}<stack> = $stack;
    update_state($s_full);
    say "generator: <<RAKU";
    say "!raku";
    say "use NginxParser;";
    say 'parse-server(%ind%);';
    say "RAKU";
  } else {
    say "generator: <<RAKU";
    say "!raku";
    say "use NginxParser;";
    say 'parse-server(%ind%)';
    say "RAKU";
  }
OK
CODE

}