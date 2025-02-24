#!raku

use v6;

# DSL implimentation

unit module Sparrow6::DSL;

use Sparrow6::Common::Config;
use Sparrow6::DSL::Common;
use Sparrow6::DSL::Assert;
use Sparrow6::DSL::Bash;
use Sparrow6::DSL::Directory;
use Sparrow6::DSL::File;
use Sparrow6::DSL::Git;
use Sparrow6::DSL::Group;
use Sparrow6::DSL::Package;
use Sparrow6::DSL::CPAN::Package;
use Sparrow6::DSL::Service;
use Sparrow6::DSL::Ssh;
use Sparrow6::DSL::Systemd;
use Sparrow6::DSL::Template;
use Sparrow6::DSL::Template6;
use Sparrow6::DSL::User;
use Sparrow6::DSL::Zef;


my package EXPORT::DEFAULT { } # initialise the export namespace

BEGIN for <
&config
&set-config
&task-run
&task_run
&tags
&parse-tags
&module-run
&bash
&directory
&directory-create
&directory-delete
&file
&file-create
&file-delete
&copy-local-file
&user
&user-create
&user-delete
&group
&group-create
&group-delete
&proc-exists
&proc-exists-by-pid
&proc-exists-by-footprint
&http-ok
&cpan-package
&cpan-package-install
&package-install
&git-scm
&proc-exists
&proc-exists-by-footprint
&proc-exists-by-pid
&service
&service-start
&service-stop
&service-enable
&service-disable
&service-restart
&systemd-service
&template
&template-create
&ssh
&scp
&target_os
&os
&os-resolver
&zef
> { # iterate over the things you want to
  #re-export by default
  EXPORT::DEFAULT::{$_} = ::($_)
}

