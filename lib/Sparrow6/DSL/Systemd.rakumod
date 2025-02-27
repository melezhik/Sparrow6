use v6;

unit module Sparrow6::DSL::Systemd;

use Sparrow6::DSL::Common;

use Sparrow6::DSL::Template6;
use Sparrow6::DSL::Bash;

sub systemd-service( $name, %opts? ) is export {

    my %params = %opts;

    my $templ = "[Unit]
Description=[% name %]
After=network.target

[Service]
Type=simple
User=[% user %]
WorkingDirectory=[% workdir %]
ExecStart=[% command %]
Restart=on-failure

[Install]
WantedBy=multi-user.target
";

  %opts<name> = $name;

  my $path = %opts<dry-run> ?? "/tmp/out.service" !! "/etc/systemd/system/$name.service";
  my %st = template6 $path, %(
    content => $templ,
    vars => %opts,
  );

  say "$path changed" if %st<status> != 0;

  if %st<status> != 0 && ! %opts<dry-run> {
      bash "systemctl daemon-reload"
  }  
}




