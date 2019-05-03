use v6;

unit module Sparrow6::DSL::Package;

use Sparrow6::DSL::Common;

multi sub package-install ( @list ) is export {

    task-run "install package(s): {@list.perl}", "package-generic", %(
      list        => (join ' ', @list),
      action      => 'install',
    );

}

multi sub package-install ( %list ) is export {

    task-run "install package(s): {%list.perl}", "package-generic", %(
      list        => %list,
      action      => 'install',
    );

}

multi sub package-install ( $list ) is export {

    task-run "install package(s): $list.perl", "package-generic", %(
        list        => $list,
        action      => 'install'
    );

}

 
