#!raku

unit module Sparrow6::Task::Runner::Helpers::Php;
use JSON::Fast;

role Role {


  method !make-sparrow6-php-lib ($path) {

      my $fh = open $.cache-dir ~ '/sparrow6lib.php', :w;
      $fh.print(slurp %?RESOURCES<sparrow6lib.php>);
      $fh.close;

      self!log("php lib deployed","{$.cache-dir}/sparrow6lib.php");

  }

  method !deploy-php-helpers ($path) {

      self!log("deploy php helpers","start");

      self!make-sparrow6-common-lib($path);

      self!make-php-glue($path);

      self!make-sparrow6-php-lib($path);

  }

  method !deploy-php-run-cmd ($path) {

      my $cmd;

      $cmd ~= "php -d auto_prepend_file={$.cache-dir}/init.php  $path";

      my $fh = open $.cache-dir ~ '/init.php', :w;
      $fh.say("<?php");
      $fh.say("include \"{$.cache-dir}/glue.php\";");
      $fh.say("include \"{$.cache-dir}/sparrow6lib.php\";");
      $fh.say("?>");
      $fh.close;

      $fh = open $.cache-dir ~ '/cmd.bash', :w;
      $fh.say("set -e");
      $fh.say($cmd);
      $fh.close;

      self!log("php run cmd", $cmd);

      return "bash {$.cache-dir}/cmd.bash"
  }


  method !make-php-glue ($path) {

      my $stdout-file = $.cache-dir ~ '/stdout';

      if $stdout-file.IO ~~ :e {
        unlink $stdout-file;
        self!log("remove stdout file", $stdout-file);
      }

      my $fh = open $.cache-dir ~ '/glue.php', :w;
      $fh.say("<?php");
      $fh.say("function root_dir()\n\{\n\treturn \"" ~ $.root.IO.absolute ~ "\";\n\}\n" );
      $fh.say("function os()\n\{\n\treturn \"" ~ $.os  ~ "\";\n\}\n" );
      $fh.say("// project_root_directory is deprecated");
      $fh.say("function project_root_dir()\n\{\n\treturn \"" ~ $.root.IO.absolute  ~ "\";\n\}\n" );
      $fh.say("function task_dir()\n\{\n\t return \"" ~ $path.IO.dirname.IO.absolute  ~ "\";\n\}\n" );
      $fh.say("function cache_root_dir()\n\{\n\t return \"" ~ $.cache-root-dir  ~ "\";\n\}\n" );
      $fh.say("// test_root_dir is deprecated");
      $fh.say("function test_root_dir()\n\{\n\t return \"" ~ $.cache-root-dir   ~ "\";\n\}\n" );
      $fh.say("function cache_dir()\n\{\n\t return \"" ~ $.cache-dir  ~ "\";\n\}\n" );
      $fh.say("function stdout_file()\n\{\n\t return \"" ~ $stdout-file ~ "\";\n\}\n" );
      $fh.say("?>");
      $fh.close;

      self!log("php glue deployed", "{$.cache-dir}/glue.php");

  }

  method !run-php-task ($path) {

      self!log("run php task", $path);

      self!deploy-php-helpers($path);

      my $cmd = self!deploy-php-run-cmd($path);

      self!log("php task cmd deployed", $cmd);

      self.console-header("task run: {$path.IO.basename} - {self.name}");

      self.dump-code($path) if %*ENV<SP6_DUMP_TASK_CODE> and self.code-dumpable;

      self!run-command-async($cmd);

  }

  method !run-php-hook ($path) {

    self!log("run php hook", $path);

    self!deploy-php-helpers($path);

    my $cmd-path = self!deploy-php-run-cmd($path);

    self!log("php hook cmd deployed", $cmd-path );

    my $bash-cmd = self!run-command($cmd-path);

    my $task-vars;

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

      if $line ~~ /'task_var_json_begin' .* / ff $line ~~ /'task_var_json_end' .*/ {
        $task-vars ~= $line;
        next;
      }

      if $line ~~ /task":" \s+ (\S+)/ {
        my $s = $0;
        $task-vars ~~ s/'task_var_json_begin'//;
        $task-vars ~~ s/'task_var_json_end'//;
        self.task-vars = from-json($task-vars||'{}');  
        self!run-task("{$.root}/tasks/$s");
        $task-vars = '';
      }

    }

    self!handle-hook-status($bash-cmd);

    self!process-stdout-from-hook($path);

  }

}


