use v6;

unit module Sparrow6::DSL::Template6;

use Sparrow6::DSL::Common;

sub template6-create ( $target, %opts? ) is export {

    my %params = %opts;

    %params<vars> = Hash.new unless %params<vars>:exists;

    %params<target> = $target;

    task-run  %(
      task        => "create template6 $target",
      plugin      => 'template6',
      parameters  => %params
    );

}

sub template6 ( $target , %opts = %() ) is export { template6-create $target, %opts }



