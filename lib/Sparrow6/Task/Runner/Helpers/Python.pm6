#!perl6

unit module Sparrow6::Task::Runner::Helpers::Python;
use JSON::Tiny;

role Role {


  method !make-sparrow6-python-lib ($path) {

      my $fh = open $.cache-root-dir ~ $path ~ '/sparrow6lib.py', :w;
      $fh.say(slurp %?RESOURCES<sparrow6lib.py>.Str);
      $fh.close;

      self!log("python lib deployed","{$.cache-root-dir}$path/sparrow6lib.py");

  }

  method !deploy-python-helpers ($path) {

      self!log("deploy python helpers","start");

      self!make-sparrow6-common-lib($path);

      self!make-python-glue($path);

      self!make-sparrow6-python-lib($path);

  }

  method !deploy-python-run-cmd ($path) {

      my $cmd = "export PYTHONPATH=\$PYTHONPATH:" ~ $.cache-root-dir ~ $path ~ " && python $path";

      self!log("python run cmd", $cmd);

      my $fh = open $.cache-root-dir ~ $path ~ '/cmd.bash', :w;
      $fh.say("set -e");
      $fh.say($cmd);
      $fh.close;

      return $.cache-root-dir ~ $path ~ '/cmd.bash'
  }


  method !make-python-glue ($path) {

      my $stdout-file = $.cache-root-dir ~ $path ~ '/stdout';

      if $stdout-file.IO ~~ :e {
        unlink $stdout-file;
        self!log("remove stdout file", $stdout-file);
      }

      my $fh = open $.cache-root-dir ~ $path ~ '/glue.py', :w;
      $fh.say("def root_dir():\n\treturn '" ~ $.root.IO.absolute ~ "'\n" );
      $fh.say("def os():\n\treturn '" ~ $.os ~ "'\n" );
      $fh.say("# project_root_directory is deprecated");
      $fh.say("def project_root_dir():\n\treturn '" ~ $.root.IO.absolute ~ "'\n" );
      $fh.say("def task_dir():\n\treturn '" ~ $path.IO.dirname.IO.absolute ~ "'\n" );
      $fh.say("def cache_root_dir():\n\treturn '" ~ $.cache-root-dir ~ "'\n" );
      $fh.say("# test_root_dir is deprecated");
      $fh.say("def test_root_dir():\n\treturn '" ~ $.cache-root-dir ~ "'\n" );
      $fh.say("def cache_dir():\n\treturn '" ~ $.cache-root-dir ~ $path ~ "'\n" );
      $fh.say("def stdout_file():\n\treturn '" ~ $stdout-file ~ "'\n" );
      $fh.close;

      self!log("python glue deployed", "{$.cache-root-dir}$path/glue.py");

  }

  method !run-python-task ($path) {

      self!log("run python task", $path);

      self!deploy-python-helpers($path);

      my $cmd = self!deploy-python-run-cmd($path);

      self!log("python task cmd deployed", $cmd);

      my $bash-cmd = self!bash-command($cmd);

      self!capture-cmd-output($bash-cmd);

      self!handle-task-status($bash-cmd);

  }

  method !run-python-hook ($path) {

    self!log("run python hook", $path);

    self!deploy-python-helpers($path);

    my $cmd-path = self!deploy-python-run-cmd($path);

    self!log("python hook cmd deployed", $cmd-path );

    my $bash-cmd = self!bash-command($cmd-path);

    my $task-vars;

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

      if $line ~~ /'task_var_json_begin' .* / ff $line ~~ /'task_var_json_end' .*/ {
        $task-vars ~= $line;
        next;
      }

      if $line ~~ /task":" \s+ (\S+)/ {
        my $s = $0;
        $task-vars ~~ s/'task_var_json_begin'//;
        $task-vars ~~ s/'task_var_json_end'//;
        self.task-vars = from-json($task-vars||'{}');  
        self!run-task("{$.root}/modules/$s");
        $task-vars = '';
      }

    }

    self!handle-hook-status($bash-cmd);

    self!process-stdout-from-hook($path);

  }

}


