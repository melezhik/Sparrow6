unit module Sparrow6::Task::Repository::Helpers::Init;

role Role {

  method repo-init ($repo-root) {

    die "usage: repo-init \$repo-root" unless $repo-root.defined;

    self.console-with-prefix("initialize Sparrow6 repository for $repo-root ");

    mkdir "$repo-root/plugins/";

    mkdir "$repo-root/api/v1";

    shell("touch $repo-root/api/v1/index");


  }

}
