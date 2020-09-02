# Sparrow6::Task::Repository API

Sparrow6::Task::Repository API is an internal API to interact with Sparrow6 repositories, you probably don't need to
get into it's guts, but if you do, here is briefly outlined API.

Index update

    #!raku

    use Sparrow6::Task::Repository;

    Sparrow6::Task::Repository::Api.new(
      url => "file:///var/sparrow-local-repo",
      debug => True,
    ).index-update;


Plugin install

    #!raku

    use Sparrow6::Task::Repository;

    Sparrow6::Task::Repository::Api.new(
      url     => "http://192.168.0.1",
      debug   => True,
    ).plugin-install("foo-test");


