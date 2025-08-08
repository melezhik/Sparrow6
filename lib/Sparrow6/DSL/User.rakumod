use v6;

unit module Sparrow6::DSL::User;

use Sparrow6::DSL::Common;

sub user-create ( $name ) is export {

  task-run "create user $name", "user", %(
      :$name,
      :action<create>,
  );

}

multi sub user ( $name, %args ) is export {

    my %params = %args; 

    %params<action> = "create" unless %params<action>:exists;
    %params<name> = $name;

    task-run "create user $name", "user", %params;

}

multi sub user ( $name )  is export { user-create $name }

sub user-delete ( $name ) is export {

  task-run "delete user $name", "user", %(
      :$name,
      :action<delete>,
  );

}

