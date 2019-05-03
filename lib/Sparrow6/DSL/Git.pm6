use v6;

unit module Sparrow6::DSL::Git;

use Sparrow6::DSL::Common;

use Sparrow6::DSL::Bash;


multi sub git-scm ( $source, %args? ) is export {

  my $cd-cmd = %args<to> ?? "cd " ~ %args<to> ~ ' && pwd ' !! 'pwd';

  %args<accept-hostkey> = Bool.new( False ) if not %args<accept-hostkey>;

  my @git-ssh-opts = Array.new;
  @git-ssh-opts.push: 'ssh';
  @git-ssh-opts.push: "-i %args<ssh-key>" if %args<ssh-key>;
  @git-ssh-opts.push: "-o StrictHostKeyChecking=no" if %args<accept-hostkey> == True;

  my %bash-args = Hash.new;
  %bash-args<description> = "git checkout $source";
  %bash-args<user> = %args<user> if %args<user>;
  %bash-args<debug> = 1 if %args<debug>;
  %bash-args<envvars><GIT_SSH_COMMAND> = '"' ~ ( join ' ', @git-ssh-opts ) ~ '"';

  bash qq:to/HERE/, %bash-args;
    set -e;
    $cd-cmd &&
    if test -d .git; then
      git pull
    else
      git clone $source .
    fi
  HERE

  if %args<branch> {
    %bash-args<description> = "git checkout remote branch " ~ %args<branch>;
    bash qq:to/HERE/, %bash-args;
      set -e;
      $cd-cmd
      git checkout %args<branch>
      git pull
    HERE
  }

}


