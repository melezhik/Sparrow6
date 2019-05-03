use v6;

unit module Sparrow6::DSL::Ssh;

use Sparrow6::DSL::Common;
use Sparrow6::DSL::Bash;
use Sparrow6::DSL::Directory;
use Sparrow6::DSL::File;

multi sub ssh ( %args ) is export { 
  ssh %args<command>, %args;
}

multi sub ssh ( $command, %args ) is export { 

  my $ssh-cache-dir = %*ENV<HOME> ~ "/.sparrow6/.ssh/" ~ $*PID   ~ 22.rand.Int.Str;

  directory $ssh-cache-dir;

  if %args<ssh-key>:exists {
    file "{$ssh-cache-dir}/ssh-key", %( 
      content => ( slurp %args<ssh-key> ),
      mode => '0600'
    );
  }

  my $ssh-host-term = %args<user>:exists ?? %args<user> ~ '@' ~ %args<host> !! %args<host>;


  my $ssh-run-cmd  =  'ssh -o ConnectionAttempts=1  -o ConnectTimeout=10';

  $ssh-run-cmd ~= ' -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -tt';

  $ssh-run-cmd ~= ' -q' ;

  $ssh-run-cmd ~= " -i {$ssh-cache-dir}/ssh-key" if %args<ssh-key>:exists;

  $ssh-run-cmd ~= " $ssh-host-term '$command'";

  my $bash-cmd;

  if %args<create>:exists {
    $bash-cmd = "if ! test -f %args<create> ; then set -x; $ssh-run-cmd ; else echo skip due to %args<create> exists; fi"    
  } else {
    $bash-cmd = "set -x; $ssh-run-cmd"
  }

  bash $bash-cmd, %(
    description => %args<description> ||  "remote command on $ssh-host-term",
    debug       => %args<debug>:exists ?? 1 !! 0,
  );

  file-delete "{$ssh-cache-dir}/ssh-key" if %args<ssh-key>:exists;

  file %args<create> if %args<create>:exists;

}

sub scp ( %args ) is export { 

  my $ssh-cache-dir = %*ENV<HOME> ~ "/.sparrow6/.ssh/" ~ $*PID   ~ 22.rand.Int.Str;

  directory $ssh-cache-dir;

  if %args<ssh-key>:exists {
    file "{$ssh-cache-dir}/ssh-key", %( 
      content => ( slurp %args<ssh-key> ),
      mode => '0600'
    );
  }


  my $scp-run-cmd  =  'scp -o ConnectionAttempts=1  -o ConnectTimeout=10';

  $scp-run-cmd ~= ' -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no';

  $scp-run-cmd ~= ' -q' ;

  $scp-run-cmd ~= " -i {$ssh-cache-dir}/ssh-key" if %args<ssh-key>:exists;

  my $ssh-host-term;

  if  %args<pull> {
    if %args<user> {
      for %args<host>.words -> $w {  $ssh-host-term ~= ' ' ~ %args<user> ~ '@' ~ $w }
    } else {
      $ssh-host-term = %args<host>
    }

    $scp-run-cmd ~= " $ssh-host-term %args<data>";

  } else {

    $ssh-host-term = %args<user>:exists ?? %args<user> ~ '@' ~ %args<host> !! %args<host>;

    $scp-run-cmd ~= " %args<data> $ssh-host-term";

  }

  my $bash-cmd;

  if %args<create>:exists {
    $bash-cmd = "if ! test -f %args<create> ; then set -x; $scp-run-cmd ; else echo skip due to %args<create> exists; fi"    
  } else {
    $bash-cmd = "set -x; $scp-run-cmd"
  }

  bash $bash-cmd, %(
    description => $scp-run-cmd,
    debug       => %args<debug>:exists ?? 1 !! 0,
  );

  file-delete "{$ssh-cache-dir}/ssh-key" if %args<ssh-key>:exists;

  file %args<create> if %args<create>:exists;

}
