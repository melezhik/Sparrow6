use v6;

unit module Sparrow6::DSL::Service;

use Sparrow6::DSL::Common;

sub service-start ( $service_id ) is export {
  service $service_id, %( action => 'start' )
}

sub service-stop ( $service_id ) is export {
  service $service_id, %( action => 'stop' )
}

sub service-restart ( $service_id ) is export {
  service $service_id, %( action => 'restart' )
}

sub service-enable ( $service_id ) is export {
  service $service_id, %( action => 'enable' )
}

sub service-disable ( $service_id ) is export {
  service $service_id, %( action => 'disable' )
}

sub service ( $service_id, %args? ) is export {

    my $action = %args<action>;

    task-run  %(
      task => "$action service $service_id",
      plugin => 'service',
      parameters => %(
        service     => $service_id,
        action      => $action,
      )
    );

}
