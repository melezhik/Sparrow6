unit module Sparrow6::Task::Repository::Helpers::Index;

role Role {

  method index-update () {

    self.get-resource("api/v1/index","{$.sparrow-root}/index");

    self!log("index updated from", "{$.url}/api/v1/index");

    self.console-with-prefix("index updated from {$.url}/api/v1/index");

    self!log("index save to", "{self!index-file}");

  }

  method repository-index-update ($plg, $version) {

    self!log("index updated", "$plg $version");

    my $url = $.url;

    $url ~~ s/^ 'file://' //;

    my %index = self!read-plugin-list("$url/api/v1/index");

    %index{$plg} = %(
      name    => $plg,
      version => $version
    );

    my $fh = open "$url/api/v1/index", :w;

    for %index.keys.sort({ %index{$^a}<name> cmp %index{$^b}<name> }) -> $i {
      $fh.say("{%index{$i}<name>} {%index{$i}<version>}");
    }

    $fh.close;

    self!log("repository index update", "$url/api/v1/index");

  }

  method !index-file () {
    "{$.sparrow-root}/index"
  }

}
