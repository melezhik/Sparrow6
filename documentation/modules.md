# Sparrow6 modules

Sparrow6 modules allow to write  portable Sparrow6 scenarios distributed as Raku modules:

    #!raku 
    
    use v6;

    unit module Sparrow6::Nginx;

    use Sparrow6::DSL;

    our sub tasks (%args) {

      package-generic "nginx";

      service-enable "nginx";

      service-start "nginx";

    }


To use module call in Sparrow6 scenario `module_run` function:


    module_run 'Nginx';

You may pass parameters to a Sparrow6 module:

    module_run 'Nginx', port => 80;

In module's definition parameters are available through `%args` Hash:

    our sub tasks (%args) {

        say %args<port>;

    }


Sparrow6 module is a standard zef module, but inside Sparrow6 scenario it is being called by shorter name:

    Sparrow6::Foo::Bar ---> module_run Foo::Bar

In other words `module_run($ModuleName)` function loads  module Sparrow6::$ModuleName at _runtime_
and calls module's function `tasks`.

