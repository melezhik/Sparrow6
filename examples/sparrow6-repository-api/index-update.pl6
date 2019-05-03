#!perl6 

use Sparrow6::Task::Repository;

Sparrow6::Task::Repository::Api.new(
  url   => %*ENV<SP6_REPO> || "file:///var/sparrow-local-repo",
  debug => %*ENV<SP6_DEBUG> ?? True !! False,
).index-update;


