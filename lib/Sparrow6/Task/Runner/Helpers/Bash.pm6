#!perl6

unit module Sparrow6::Task::Runner::Helpers::Bash;

role Role {


  method !make-sparrow6-bash-lib ($path) {

      my $fh = open $.cache-dir ~ '/sparrow6lib.bash', :w;
      $fh.say(slurp %?RESOURCES<sparrow6lib.bash>.Str);
      $fh.close;

      self!log("bash lib deployed","{$.cache-dir}/sparrow6lib.bash");

  }

  method !deploy-bash-helpers ($path) {

      self!log("deploy bash helpers","start");

      self!make-sparrow6-common-lib($path);

      self!make-bash-glue($path);

      self!make-sparrow6-bash-lib($path);

  }

  method !deploy-bash-run-cmd ($path) {

    my $fh = open $.cache-dir ~ '/cmd.bash', :w;

    if "{$.root}/lib".IO ~~ :d {
      $fh.say("# export lib to task Perl env");
      $fh.say("export PERL5LIB={$.root}/lib:\$PERL5LIB");
      $fh.say("# export lib to task Ruby env");
      $fh.say("export RUBYLIB={$.root}/lib:\$RUBYLIB");
      $fh.say("# export lib to task Python env");
      $fh.say("export PYTHONPATH={$.root}/lib:\$PYTHONPATH");
      $fh.say("# export lib to task Raku env");
      $fh.say("export RAKULIB=file\#{$.root}/lib,\$RAKULIB");
    }

    if "{$.root}/bin".IO ~~ :d {
      $fh.say("");
      $fh.say("# export bin to task PATH");
      $fh.say("export PATH={$.root}/bin/:\$PATH");
      $fh.say("");
    }

    if "{$.root}/cpanfile".IO ~~ :e {
      self!log("pick up cpanfile","{$.root}/cpanfile");
      $fh.say("# pick up cpanfile from {$.root}/cpanfile");
      $fh.say("export PATH={$.root}/local/bin/:\$PATH");
      $fh.say("export PERL5LIB={$.root}/local/lib/perl5:\$PERL5LIB");
      $fh.say("");
    }


    if "{$.root}/requirements.txt".IO ~~ :e {
      self!log("pick up requirements.txt","{$.root}/requirements.txt");
      $fh.say("export PATH={$.root}/python-lib/bin/:\$PATH");
      $fh.say("export PYTHONPATH={$.root}/python-lib:\$PYTHONPATH");
      $fh.say("");
    }

    if "{$.root}/rakufile".IO ~~ :e {
      self!log("pick up rakufile","{$.root}/rakufile");
      $fh.say("# pick up rakufile from {$.root}/rakufile");
      $fh.say("export PATH={$.root}/raku-lib/bin/:\$PATH");
      $fh.say("export RAKULIB=\"inst\#{$.root}/raku-lib\",\$RAKULIB");
      $fh.say("");
    }

    $fh.say("source " ~  $.cache-dir ~ '/glue.bash');
    $fh.say("source " ~  $.cache-dir ~ '/sparrow6lib.bash');
    $fh.say("source " ~  $.cache-dir ~ '/variables.bash');
    $fh.say("source $path");
    $fh.close;

    self!log("bash run cmd", "bash {$.cache-dir}/cmd.bash");

    return "bash {$.cache-dir}/cmd.bash";

  }


  method !make-bash-glue ($path) {

      my $stdout-file = $.cache-dir ~ '/stdout';

      if $stdout-file.IO ~~ :e {
        unlink $stdout-file;
        self!log("remove stdout file", $stdout-file);
      }

      my $fh = open $.cache-dir ~ '/glue.bash', :w;
      $fh.say("root_dir=", $.root.IO.absolute);
      $fh.say("os=", $.os);
      $fh.say("# project_root_directory is deprecated");
      $fh.say("project_root_dir=", $.root.IO.absolute);
      $fh.say("task_dir=", $path.IO.dirname.IO.absolute);
      $fh.say("# test_root_dir is deprecated");
      $fh.say("test_root_dir=", $.cache-root-dir);
      $fh.say("cache_root_dir=", $.cache-root-dir);
      $fh.say("cache_dir=", $.cache-dir );
      $fh.say("stdout_file=", $stdout-file );
      $fh.close;

      self!log("bash glue deployed", "{$.cache-dir}/glue.bash deployed");

  }

  method !run-bash-task ($path) {

    self!log("run bash task",$path);

    self!deploy-bash-helpers($path);

    my $cmd = self!deploy-bash-run-cmd($path);

    self!log("bash task cmd deployed", $cmd);

    self!run-command-async($cmd);

  }

  method !run-bash-hook ($path) {

    self!log("run bash hook", $path);

    self!deploy-bash-helpers($path);

    my $cmd = self!deploy-bash-run-cmd($path);

    self!log("bash hook cmd deployed", $cmd);

    my $bash-cmd = self!run-command($cmd);

    my %task-vars;

    for $bash-cmd.out.lines -> $line {
      self!log("stdout",$line);

      if $line ~~ / 'ignore_task_error:' / {
        $.ignore-task-error = True;
        self!log("ingnore task errors","enabled");
      }

      if $line ~~ / 'ignore_error:' / {
        $.ignore-task-error = True;
        self!log("ingnore task errors","enabled");
      }

      if $line ~~ /'task_var_bash:' \s+ (\S+) \s+ (.*)/ {
        %task-vars{"$0"}="$1";
        next;
      }

      if $line ~~ /task":" \s+ (\S+)/ {
        self.task-vars = %task-vars;
        self!run-task("{$.root}/tasks/$0");
        %task-vars = %();
      }
    }

    self!handle-hook-status($bash-cmd);

    self!process-stdout-from-hook($path);

  }

}

