#!perl6

use v6;

unit module Sparrow6::DSL::File;

use Sparrow6::DSL::Common;

sub file-create ( $target, %opts? ) is export {

    my %params = %opts;

    %params<target> = $target;

    %params<action> = 'create';

    if %params<source>:exists and %params<content>:exists {
      die "can't use both source and content parameters"
    }

    task-run  %(
      task        => "create file $target",
      plugin      => 'file',
      parameters  => %params
    );
  
}

# this function is kept
# only for back compatibility
# in Sparrow6
# you can just use method `copy` instead
# https://docs.perl6.org/routine/copy

sub copy-local-file ($from, $to) is export {
  copy $from, $to
}


multi sub file ( $target , %opts = %() ) is export { file-create $target, %opts }

sub file-delete ( $target ) is export {

    my %params = Hash.new;

    %params<target> = $target;
    %params<action> = 'delete';

    task-run  %(
      task        => "delete file $target",
      plugin      => 'file',
      parameters  => %params
    );

}


