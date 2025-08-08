use v6;

unit module Sparrow6::DSL::Group;

use Sparrow6::DSL::Common;

sub group-create ( $name ) is export {

  task-run "create group $name", "group", %(
      :$name,
      :action<create>,
  );

}

multi sub group ( $name, %args ) is export {

    my %params = %args; 

    %params<action> = "create" unless %params<action>:exists;
    %params<name> = $name;

    task-run "create group $name", "group", %params;

}

multi sub group ( $name )  is export { group-create $name }

sub group-delete ( $name ) is export {

  task-run "delete group $name", "group", %(
      :$name,
      :action<delete>,
  );

}

sub group-exists ( $name ) is export {

  my $s = task-run "check if group $name exists", "group", %(
      :$name,
      :action<exists>,
  );

  return $s;
  
}
