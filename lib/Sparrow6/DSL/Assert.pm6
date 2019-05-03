use v6;

unit module Sparrow6::DSL::Assert;

use Sparrow6::DSL::Common;
use Sparrow6::DSL::Bash;

multi sub proc-exists ( $proc, %params? ) is export {

    my %args = Hash.new;

    %args<pid_file>   = %params<pid_file>     if %params<pid_file>:exists;
    %args<pid_file>   = %params<pid-file>     if %params<pid-file>:exists;
    %args<footprint>  = %params<footprint>    if %params<footprint>:exists;

    task-run "check $proc process", "proc-validate",  %args;
    
}

multi sub proc-exists ( $proc ) is export {
  proc-exists $proc, %( pid-file => "/var/run/$proc" ~ '.pid' )
}

sub proc-exists-by-pid ( $proc, $pid-file ) is export {
  proc-exists $proc, %( pid-file => $pid-file )
}

sub proc-exists-by-footprint ( $proc, $fp ) is export {
  proc-exists($proc, %( footprint => $fp ))
}

multi sub http-ok ( $url, %args? ) is export {

  my $curl-cmd = "curl -fsSLk -D - --retry 3 $url";

  $curl-cmd ~= ":%args<port>" if %args<port>;
  $curl-cmd ~= "%args<path>"  if %args<path>;
  $curl-cmd ~= " --noproxy 127.0.0.1" if %args<no-proxy>;

  my %bash-args =  %( debug => True );

  if %args<has-content> {
    %bash-args<expect_stdout> = %args<has-content> 
  } else {
    $curl-cmd ~= " -o /dev/null"
  }

  bash $curl-cmd, %bash-args;

}

multi sub http-ok () is export {

  http-ok("127.0.0.1");

}

multi sub http-ok ( %args ) is export {

  http-ok("127.0.0.1", %args);

}


