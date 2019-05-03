#!perl6

use v6;

unit module Sparrow6::S6;


sub s6-help () is export  {
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

  options:
    --debug   # enable debug mode
  DOC
}
