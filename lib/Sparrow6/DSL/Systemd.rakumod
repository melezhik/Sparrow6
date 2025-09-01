use v6;

unit module Sparrow6::DSL::Systemd;

use Sparrow6::DSL::Common;

use Sparrow6::DSL::Template6;
use Sparrow6::DSL::Bash;

sub systemd-service( $name, %opts? ) is export {

    my %params = %opts;

    my $s = task-run "systemd unit for $name", "systemd-service-unit", %(
      :name($name),
      :description(%opts<description> || "$name service"),
      :type(%opts<type>||"simple"),
      :exec_start(%opts<command>||""),
      :restart(%opts<restart>||"failure"),
      :workdir(%opts<workdir>||""),
      :user(%opts<user>||""),
      :environment(%opts<environment>:exists ?? %opts<environment> !! ""),
      :dry_run(%opts<dry-run>:exists ?? %opts<dry-run> !! False),
    ); 

  say "unit for $name changed" if $s<changed>;

  if $s<changed> && ! %opts<dry-run> {
      bash "systemctl daemon-reload"
  }  
}




