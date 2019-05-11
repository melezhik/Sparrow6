#!perl6

use v6;

unit module Sparrow6::Task;

use Sparrow6::Common::Helpers;

class Cli

  does Sparrow6::Common::Helpers::Role

{

  has Bool  $.debug = %*ENV<SP6_DEBUG> ?? True !! False ;
  has Str   $.name = "task-cli";

  method help () {
  
    say q:to/DOC/;

    usage:
      s6 $action|$options $thing
  
    update index:
      s6 --index-update
  
    list installed plugins:
      s6 --list
  
    upload plugin:
      s6 --upload
  
    install plugin:
      s6 --install $plugin
      s6 --install --force $plugin # reinstall, even though if higher version is here

    run plugin:
      s6 --run plg-name@param1=value2,@param2=value2
  
    options:
      --debug   # enable debug mode


DOC
  }
  
  method run ($thing)  {
  
  }
  
}
