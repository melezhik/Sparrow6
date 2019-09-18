#!perl6

use v6;

# Repository API implimentation

unit module Sparrow6::Task::Repository;

use JSON::Tiny;

use Sparrow6::Common::Helpers;
use Sparrow6::Task::Repository::Helpers::Common;
use Sparrow6::Task::Repository::Helpers::qPlugin;
use Sparrow6::Task::Repository::Helpers::Index;
use Sparrow6::Task::Repository::Helpers::Init;

class Api 

  does Sparrow6::Common::Helpers::Role
  does Sparrow6::Task::Repository::Helpers::Common::Role
  does Sparrow6::Task::Repository::Helpers::Plugin::Role 
  does Sparrow6::Task::Repository::Helpers::Index::Role 
  does Sparrow6::Task::Repository::Helpers::Init::Role 

{

  has Str   $.url = %*ENV<SP6_REPO> || ( $*DISTRO.is-win ?? "file://{%*ENV<HOMEDRIVE>}{%*ENV<HOMEPATH>}/repo" !! "file://{%*ENV<HOME>}/repo" ) ;
  has Str   $.sparrow-root is rw;
  has Str   $.prefix;
  has Bool  $.debug = %*ENV<SP6_DEBUG> ?? True !! False ;
  has Str   $.name = "repository";

  method TWEAK() {

    self!set-sparrow-root();

  }
}
