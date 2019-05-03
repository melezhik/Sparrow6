#!perl6

use v6;

unit module Sparrow6::DSL::CPAN::Package;

use Sparrow6::DSL::Common;

multi sub cpan-package-install ( @list, %opts? ) is export {

    my %params = Hash.new;

    %params<list> = join ' ', @list;

    %params<install-base> = %opts<install-base> if %opts<install-base>:exists; 
    %params<user> = %opts<user> if %opts<user>:exists; 

    %params<http_proxy> = %opts<http-proxy> if %opts<http-proxy>:exists; 
    %params<https_proxy> = %opts<https-proxy> if %opts<https-proxy>:exists; 

    task_run  %(
      task => "install cpan packages: " ~ (join ' ', @list),
      plugin => 'cpan-package',
      parameters => %params 
    );

}

multi sub cpan-package ( @list, %opts? ) is export { cpan-package-install @list, %opts  } # alias

multi sub cpan-package ( $list, %opts? ) is export { cpan-package-install  $list, %opts  } # alias

multi sub cpan-package-install ( $list, %opts? ) is export {

    my %params = Hash.new;

    %params<list> = $list;

    %params<install-base> = %opts<install-base> if %opts<install-base>:exists; 
    %params<user> = %opts<user> if %opts<user>:exists; 

    %params<http_proxy> = %opts<http-proxy> if %opts<http-proxy>:exists; 
    %params<https_proxy> = %opts<https-proxy> if %opts<https-proxy>:exists; 

    task_run  %(
      task => "install cpan packages: $list",
      plugin => 'cpan-package',
      parameters => %params 
    );

}

