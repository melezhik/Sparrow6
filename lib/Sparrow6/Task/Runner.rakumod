#!raku

use v6;

unit module Sparrow6::Task::Runner;

use File::Directory::Tree;
use Hash::Merge;

use YAMLish;
use JSON::Fast;

use Sparrow6::Common::Helpers;
use Sparrow6::Common::Config;
use Sparrow6::Task::Runner::Helpers::Common;
use Sparrow6::Task::Runner::Helpers::Raku;
use Sparrow6::Task::Runner::Helpers::Perl;
use Sparrow6::Task::Runner::Helpers::Bash;
use Sparrow6::Task::Runner::Helpers::Ruby;
use Sparrow6::Task::Runner::Helpers::Python;
use Sparrow6::Task::Runner::Helpers::Powershell;
use Sparrow6::Task::Runner::Helpers::Test;
use Sparrow6::Task::Runner::Helpers::Check;
use Data::Dump;

class Api

  does Sparrow6::Common::Helpers::Role
  does Sparrow6::Task::Runner::Helpers::Common::Role
  does Sparrow6::Task::Runner::Helpers::Raku::Role
  does Sparrow6::Task::Runner::Helpers::Perl::Role
  does Sparrow6::Task::Runner::Helpers::Bash::Role
  does Sparrow6::Task::Runner::Helpers::Ruby::Role
  does Sparrow6::Task::Runner::Helpers::Python::Role
  does Sparrow6::Task::Runner::Helpers::Powershell::Role
  does Sparrow6::Task::Runner::Helpers::Test::Role
  does Sparrow6::Task::Runner::Helpers::Check::Role

  {

  has Str   $.root is required is rw;
  has Str   $.task is rw;
  has Str   $.sparrow-root;
  has Bool  $.debug = %*ENV<SP6_DEBUG> ?? True !! False;
  has Str   $.os = os();
  has Hash  $.parameters;
  has Str   $.config      is rw;
  has Hash  $.task-config is rw;
  has Str   $.cache-dir is rw;
  has Str   $.cache-root-dir is rw;
  has Str   $.name is required is rw;
  has Str   @.stdout-data is rw;
  has Str   @.stderr-data is rw;
  has Hash  $.task-vars is rw;
  has Bool  $.test-pass is rw;
  has Bool  $.check-pass is rw;
  has Bool  $.keep-cache is rw;
  has Bool  $.do-test;
  has Bool  $.show-test-result;
  has Bool  $.ignore-task-error is rw;
  has Bool  $.ignore-task-check-error is rw;
  has Int   $.task-check-err-cnt is rw;
  has Str   $.cwd = "{$*CWD}";
  has Bool  $.silent-stdout is rw;
  has Bool  $.silent-stderr is rw;
  has Bool  $.code-dumpable is rw = True;

  my $task-run = 0;

  method TWEAK() {

    $.root = "$.root".IO.absolute;

    unless $.config {
      $.config = "{$.root}/config.raku".IO ~~ :e ?? "{$.root}/config.raku" !!  "{$.root}/config.yaml";
    }

    if $*DISTRO.is-win {

     if $.sparrow-root {
      $.cache-root-dir = $.sparrow-root ~ "/tmp/" ~ $*PID ~ 22.rand.Int.Str
     } else {
      $.cache-root-dir = "{%*ENV<HOMEDRIVE>}{%*ENV<HOMEPATH>}" ~ "/.sparrow6/tmp/" ~ $*PID   ~ 22.rand.Int.Str
     }

    } else {

     if $.sparrow-root {
        $.cache-root-dir = $.sparrow-root ~ "/tmp/" ~ $*PID ~ 22.rand.Int.Str
     } else {
        $.cache-root-dir = %*ENV<HOME> ~ "/.sparrow6/tmp/" ~ $*PID   ~ 22.rand.Int.Str
     }

    }

    if $.cache-root-dir.IO ~~ :e {
      empty-directory $.cache-root-dir;
      self!log("cache root dir erased", "$.cache-root-dir");
    }

    mkdir $.cache-root-dir;

    self!log("cache root dir created", "$.cache-root-dir");

    if $.config.IO ~~ :e {

      self!log("load plugin configuration file",$.config);
      my $plugin-config = $.config ~~ / '.raku' $$/ ?? EVALFILE($.config) !! load-yaml(slurp $.config);
      self!log("parse plugin configuration file",$plugin-config.perl);
      self!log("input parameters",$.parameters.perl);
      self.task-config = merge-hash $plugin-config, $.parameters, :!positional-append;
      self!log("merged task config",$.task-config.perl);

    } else { # handle case when task config does not exist

      self!log("plugin has no configuration file","hope it's ok");
      self!log("input parameters",$.parameters.perl);
      self.task-config = merge-hash %(), $.parameters;
      self!log("merged task config",$.task-config.perl);

    }

    # stringify <args>
    if self.task-config<args>:exists && self.task-config<args>.isa("Array") {
      my $args = self.task-config<args>;
      self!log("stringify args start, type:",$args.^name);
      self!log("stringify args start, data:",Dump($args));
      my @args; my $j = 0;
      for $args<> -> $i {
        $j++;
        self!log("args, handle element {$j}, type", $i.^name);
        self!log("args, element {$j}:", Dump($i));
        if $i.isa("Int") or $i.isa("Str") {
          push @args, $i;
        } elsif $i.isa("Hash") or $i.isa("Pair") {
          for $i.keys -> $k {
            if $k ~~ /^ '-'/ {
              push @args, $i{$k} ~~ /^\s*'='/ ??  "{$k}{$i{$k}}" !! "{$k} {$i{$k}}";
            } else {
              push @args, $i{$k} ~~ /^\s*'='/ ?? "--{$k}{$i{$k}}" !! "--{$k} {$i{$k}}"
            }
          }
        } elsif $i.isa("Array") or $i.isa("List") {
          for $i<> -> $k {
            if $k ~~ /^ '-'/ {
              push @args, $k;
            } else {
              push @args, "--{$k}"
            }
          }
        }
        else {
          die "args, element $j, unsupported type: {$i.^name}"
        }
      }
      self!log("stringified args",@args.join(' '));
      self.task-config<args> = @args.join(' ');
    }

    my $fh = open "{$.cache-root-dir}/config.json", :w;
    $fh.say(to-json(self.task-config));
    $fh.close;
    self!log("task configuration json saved", "{$.cache-root-dir}/config.json");

    if %*ENV<SP6_DUMP_TASK_CONFIG> {
      say "task configuration:";
      say "===";
      say to-json(self.task-config);
    }
  }

  method task-run() {

    $.test-pass = True;
    $.check-pass = True;

    $.ignore-task-error = False;
    $.ignore-task-check-error = False;

    self!log("task-run(), root", $.root);
    self!log("task-run(), cwd", $.cwd);
    self!log("task-run(), check-pass", $.check-pass);

    chdir $.cwd;

    self!erase-stdout-data;

    die "directory $.root does not exist" unless "$.root".IO ~~ :e;
    die "$.root is not a directory" unless "$.root".IO ~~ :d;


    if $.task {

      if $.task.IO ~~ :d {
        self!run-task($.task);
      } elsif "{$.root}/{$.task}".IO ~~ :d  {
        self!run-task("{$.root}/{$.task}");
      } else {
        die "neither {$.root}/{$.task}, nor {$.task} directory exists,\nwhat are you trying to do?";
      }

    } else {
      self!run-task($.root);
    }

    my %state = self!get-state;

    unless %*ENV<SP6_KEEP_CACHE> or $.keep-cache {
      if $.cache-root-dir.IO ~~ :e {
        empty-directory $.cache-root-dir;
        self!log("cache root dir erased", "$.cache-root-dir");
        rmdir $.cache-root-dir;
        self!log("cache root dir removed", "$.cache-root-dir");
      }
    }

    # mix in task check statistic into state
    %state<__data__> = %(
      task-check-err-cnt => $.task-check-err-cnt
    );
    return %state;

  }

  method !set-cache-dir {

    $task-run++;
    self!log("task number", $task-run);
    $.cache-dir = $.cache-root-dir ~ "/" ~ $task-run;
    mkdir $.cache-dir;
    self!log("task cache dir create", $.cache-dir );

  }

  method !reset-cache-dir {
    self!log("reset task cache dir", $.cache-dir);
    $task-run--;
    $.cache-dir = $.cache-root-dir ~ "/" ~ $task-run;
    self!log("current task cache dir", $.cache-dir);
  }

  method !run-task ($root) {

    self!log("run-task(), root", $root);
    self!log("run-task(), check-pass", $.check-pass);

    self!erase-stdout-data;

    # try to run hooks first

    if "$root/hook.raku".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-raku-hook("$root/hook.raku");

      self!reset-cache-dir();

    } elsif "$root/hook.pl6".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-raku-hook("$root/hook.pl6");

      self!reset-cache-dir();

    } elsif "$root/hook.pl".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-perl-hook("$root/hook.pl");

      self!reset-cache-dir();

    } elsif "$root/hook.bash".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-bash-hook("$root/hook.bash");

      self!reset-cache-dir();

    } elsif "$root/hook.go".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-bash-hook("$root/hook.go");

      self!reset-cache-dir();

    } elsif "$root/hook.rb".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-ruby-hook("$root/hook.rb");

      self!reset-cache-dir();

    } elsif "$root/hook.py".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-python-hook("$root/hook.py");

      self!reset-cache-dir();

    } elsif "$root/hook.ps1".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-powershell-hook("$root/hook.ps1");

      self!reset-cache-dir();

    }

    if "$root/task.raku".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-raku-task("$root/task.raku");

      self!run-task-check($root);

      if  "$root/test.raku".IO ~~ :e  and $.do-test {

        self!log("execute embeded test","$root/test.raku");

        EVALFILE "$root/test.raku";

      }

      self!reset-cache-dir();

    } elsif "$root/task.pl6".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-raku-task("$root/task.pl6");

      self!run-task-check($root);

      if  "$root/test.raku".IO ~~ :e  and $.do-test {

        self!log("execute embeded test","$root/test.raku");

        EVALFILE "$root/test.raku";

      }

      self!reset-cache-dir();

    } elsif "$root/task.pl".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-perl-task("$root/task.pl");

      self!run-task-check($root);

      if  "$root/test.raku".IO ~~ :e  and $.do-test {

        self!log("execute embeded test","$root/test.raku");

        EVALFILE "$root/test.raku";

      }

      self!reset-cache-dir();

    } elsif "$root/task.bash".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-bash-task("$root/task.bash");

      self!run-task-check($root);

      if  "$root/test.raku".IO ~~ :e  and $.do-test {

        self!log("execute embeded test","$root/test.raku");

        EVALFILE "$root/test.raku";

      }

      self!reset-cache-dir();

     } elsif "$root/task.go".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-bash-task("$root/task.go");

      self!run-task-check($root);

      if  "$root/test.raku".IO ~~ :e and $.do-test {

        self!log("execute embeded test","$root/test.raku");

        EVALFILE "$root/test.raku";

      }

      self!reset-cache-dir();

    } elsif "$root/task.rb".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-ruby-task("$root/task.rb");

      self!run-task-check($root);

      if  "$root/test.raku".IO ~~ :e  and $.do-test {

        self!log("execute embeded test","$root/test.raku");

        EVALFILE "$root/test.raku";

      }

      self!reset-cache-dir();


    } elsif "$root/task.py".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-python-task("$root/task.py");

      self!run-task-check($root);

      if  "$root/test.raku".IO ~~ :e  and $.do-test {

        self!log("execute embeded test","$root/test.raku");

        EVALFILE "$root/test.raku";

      }

      self!reset-cache-dir();

    } elsif "$root/task.ps1".IO ~~ :e {

      self!set-cache-dir();

      self!save-task-vars($.cache-dir);

      self!run-powershell-task("$root/task.ps1");

      self!run-task-check($root);

      if  "$root/test.raku".IO ~~ :e  and $.do-test {

        self!log("execute embeded test","$root/test.raku");

        EVALFILE "$root/test.raku";

      }

      self!reset-cache-dir();

    }

    my $status = 0;

    self!log("run-task() finish, root", $root);
    self!log("run-task() finish, check-pass", $.check-pass);

    if $.check-pass == False {
      say("=================\nTASK CHECK FAIL");
      $status = 2;
    }

    if $.do-test && $.test-pass == False {
      say("=================\nTEST FAIL");
      $status = 3;
    }

    exit($status) if $status != 0;

  }

}
