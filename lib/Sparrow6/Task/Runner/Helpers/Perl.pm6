#!perl6

unit module Sparrow6::Task::Runner::Helpers::Perl;
use JSON::Tiny;

role Role {


  method !make-sparrow6-perl-lib ($path) {

      my $fh = open $.cache-dir ~ '/sparrow6lib.pm', :w;
      $fh.say(slurp %?RESOURCES<sparrow6lib.pm>.Str);
      $fh.close;

      self!log("perl lib deployed","{$.cache-dir}/sparrow6lib.pm");

  }

  method !deploy-perl-helpers ($path) {

      self!log("deploy perl helpers","start");

      self!make-sparrow6-common-lib($path);

      self!make-perl-glue($path);

      self!make-sparrow6-perl-lib($path);

  }

  method !deploy-perl-run-cmd ($path) {

      my $cmd;

      if "{$.root}/cpanfile".IO ~~ :e {
        self!log("pick up cpanfile","{$.root}/cpanfile");
        $cmd = "PATH=\$PATH:{$.root}/local/bin/ &&" ;
        $cmd ~= "perl -I {$.cache-dir} ";
        $cmd ~= "-I {$.root}/local/lib/perl5 -I {$.root}/lib -Msparrow6lib $path";
      } else {
        $cmd = "perl -I {$.cache-dir} -I {$.root}/lib -Msparrow6lib $path";
      }

      my $fh = open $.cache-dir ~ '/cmd.bash', :w;
      $fh.say("set -e");
      $fh.say($cmd);
      $fh.close;

      self!log("perl run cmd", $cmd);

      return "bash {$.cache-dir}/cmd.bash"
  }


  method !make-perl-glue ($path) {

      my $stdout-file = $.cache-dir ~ '/stdout';

      if $stdout-file.IO ~~ :e {
        unlink $stdout-file;
        self!log("remove stdout file", $stdout-file);
      }

      my $fh = open $.cache-dir ~ '/glue.pm', :w;
      $fh.say("package glue;");
      $fh.say("1;");
      $fh.say("package main;");
      $fh.say('sub root_dir { q{' ~ $.root.IO.absolute ~ "}};" );
      $fh.say('sub os { qq{' ~ $.os ~ "}};" );
      $fh.say("# project_root_directory is deprecated");
      $fh.say('sub project_root_dir { q{' ~ $.root.IO.absolute ~ "}};" );
      $fh.say('sub task_dir { q{', $path.IO.dirname.IO.absolute, "}};");
      $fh.say('sub cache_root_dir { q{', $.cache-root-dir, "}};");
      $fh.say("# test_root_dir is deprecated");
      $fh.say('sub test_root_dir { q{', $.cache-root-dir, "}};");
      $fh.say('sub cache_dir { q{', $.cache-dir, "}};");
      $fh.say('sub stdout_file { q{', $stdout-file, "}};");
      $fh.close;

      self!log("perl glue deployed", "{$.cache-dir}/glue.pm");

  }

  method !run-perl-task ($path) {

      self!log("run perl task", $path);

      self!deploy-perl-helpers($path);

      my $cmd = self!deploy-perl-run-cmd($path);

      self!log("perl task cmd deployed", $cmd);

      my $bash-cmd = self!run-command($cmd);

      self!run-command-async($cmd);

  }

  method !run-perl-hook ($path) {

    self!log("run perl hook", $path);

    self!deploy-perl-helpers($path);

    my $cmd-path = self!deploy-perl-run-cmd($path);

    self!log("perl hook cmd deployed", $cmd-path );

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

      if $line ~~ / 'ignore_task_check_error:' / {
        $.ignore-task-check-error = True;
        self!log("ingnore task check errors","enabled");
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


