#!perl6

unit module Sparrow6::Task::Runner::Helpers::Bash;

role Role {


  method !make-sparrow6-bash-lib ($path) {

      my $fh = open $.cache-root-dir ~ $path ~ '/sparrow6lib.bash', :w;
      $fh.say(slurp %?RESOURCES<sparrow6lib.bash>.Str);
      $fh.close;

      self!log("bash lib deployed","{$.cache-root-dir}$path/sparrow6lib.bash");

  }

  method !deploy-bash-helpers ($path) {

      self!log("deploy bash helpers","start");

      self!make-sparrow6-common-lib($path);

      self!make-bash-glue($path);

      self!make-sparrow6-bash-lib($path);

  }

  method !deploy-bash-run-cmd ($path) {

    my $fh = open $.cache-root-dir ~ $path ~ '/cmd.bash', :w;
    $fh.say("source " ~  $.cache-root-dir ~ $path ~ '/glue.bash');
    $fh.say("source " ~  $.cache-root-dir ~ $path ~ '/sparrow6lib.bash');
    $fh.say("source " ~  $.cache-root-dir ~ $path ~ '/variables.bash');
    $fh.say("source $path");
    $fh.close;

    self!log("bash run cmd", "{$.cache-root-dir}$path/cmd.bash");

    return "{$.cache-root-dir}$path/cmd.bash";

  }


  method !make-bash-glue ($path) {

      my $stdout-file = $.cache-root-dir ~ $path ~ '/stdout';

      if $stdout-file.IO ~~ :e {
        unlink $stdout-file;
        self!log("remove stdout file", $stdout-file);
      }

      my $fh = open $.cache-root-dir ~ $path ~ '/glue.bash', :w;
      $fh.say("root_dir=", $.root.IO.absolute);
      $fh.say("os=", $.os);
      $fh.say("# project_root_directory is deprecated");
      $fh.say("project_root_dir=", $.root.IO.absolute);
      $fh.say("task_dir=", $path.IO.dirname.IO.absolute);
      $fh.say("# test_root_dir is deprecated");
      $fh.say("test_root_dir=", $.cache-root-dir);
      $fh.say("cache_root_dir=", $.cache-root-dir);
      $fh.say("cache_dir=", $.cache-root-dir ~ $path );
      $fh.say("stdout_file=", $stdout-file );
      $fh.close;

      self!log("bash glue deployed", "{$.cache-root-dir}$path/glue.bash deployed");

  }

  method !run-bash-task ($path) {

    self!log("run bash task",$path);

    self!deploy-bash-helpers($path);

    my $cmd = self!deploy-bash-run-cmd($path);

    self!log("bash task cmd deployed", $cmd);

    my $bash-cmd = self!bash-command($cmd);

    self!capture-cmd-output($bash-cmd);

    self!handle-task-status($bash-cmd);

  }

  method !run-bash-hook ($path) {

    self!log("run bash hook", $path);

    self!deploy-bash-helpers($path);

    my $cmd = self!deploy-bash-run-cmd($path);

    self!log("bash hook cmd deployed", $cmd);

    my $bash-cmd = self!bash-command($cmd);

    my %task-vars;

    for $bash-cmd.out.lines -> $line {
      self!log("stdout",$line);

      if $line ~~ / 'ignore_task_err:' / {
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
        self!run-task("{$.root}/modules/$0");
        %task-vars = %();
      }
    }

    self!handle-hook-status($bash-cmd);

    self!process-stdout-from-hook($path);

  }

}

