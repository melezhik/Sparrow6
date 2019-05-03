use v6;

unit module Sparrow6::DSL::Systemd;

use Sparrow6::DSL::Common;

use Sparrow6::DSL::Template;

sub systemd-service( $name, %opts? ) is export {

    my %params = %opts;

    my $templ = "

[Unit]
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

  template-create "/etc/systemd/system/$name.service", %(
    source => $templ,
    variables => %opts,
    on_change => 'systemctl daemon-reload'
  );
  
}




