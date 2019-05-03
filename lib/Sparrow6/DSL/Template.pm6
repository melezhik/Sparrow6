use v6;

unit module Sparrow6::DSL::Template;

use Sparrow6::DSL::Common;

sub template-create ( $target, %opts? ) is export {

    my %params = %opts;

    %params<variables> = Hash.new unless %params<variables>:exists;

    %params<target> = $target;

    task-run  %(
      task        => "create template $target",
      plugin      => 'templater',
      parameters  => %params
    );

}

sub template ( $target , %opts = %() ) is export { template-create $target, %opts }



