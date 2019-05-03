#!perl6 

use Sparrow6::Task::Repository;

Sparrow6::Task::Repository::Api.new(
  debug   => %*ENV<SP6_DEBUG> ?? True !! False,
).plugin-install("foo-test");


