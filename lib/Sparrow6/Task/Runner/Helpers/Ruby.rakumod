#!raku

unit module Sparrow6::Task::Runner::Helpers::Ruby;
use JSON::Fast;

role Role {


  method !make-sparrow6-ruby-lib ($path) {

      my $fh = open $.cache-dir ~ '/sparrow6lib.rb', :w;
      $fh.say(slurp %?RESOURCES<sparrow6lib.rb>);
      $fh.close;

      self!log("ruby lib deployed","{$.cache-dir}/sparrow6lib.rb");

  }

  method !deploy-ruby-helpers ($path) {

      self!log("deploy ruby helpers","start");

      self!make-sparrow6-common-lib($path);

      self!make-ruby-glue($path);

      self!make-sparrow6-ruby-lib($path);

  }

  method !deploy-ruby-run-cmd ($path) {

      my $cmd;

      if "{$.root}/Gemfile".IO ~~ :e {
        self!log("pick up Gemfile","{$.root}/Gemfile");
        $cmd = "cd {$.root} && bundle exec " ;
        $cmd ~= "ruby -I {$.cache-dir} ";
        $cmd ~= "-I {$.root}/lib -r sparrow6lib $path";
      } else {
        $cmd ~= "ruby -I {$.cache-dir} ";
        $cmd ~= "-I {$.root}/lib -r sparrow6lib $path";
      }

      my $fh = open $.cache-dir ~ '/cmd.bash', :w;
      $fh.say("set -e");
      $fh.say($cmd);
      $fh.close;

      self!log("ruby run cmd", $cmd);

      return "bash {$.cache-dir}/cmd.bash"
  }


  method !make-ruby-glue ($path) {

      my $stdout-file = $.cache-dir ~ '/stdout';

      if $stdout-file.IO ~~ :e {
        unlink $stdout-file;
        self!log("remove stdout file", $stdout-file);
      }

      my $fh = open $.cache-dir ~ '/glue.rb', :w;
      $fh.say("def root_dir\n\t%q|" ~ $.root.IO.absolute ~ "|\nend" );
      $fh.say("def os\n\t%q|" ~ $.os ~ "|\nend" );
      $fh.say("# project_root_directory is deprecated");
      $fh.say("def project_root_dir\n\t%q|" ~ $.root.IO.absolute ~ "|\nend" );
      $fh.say("def task_dir\n\t%q|" ~ $path.IO.dirname.IO.absolute ~ "|\nend" );
      $fh.say("def cache_root_dir\n\t%q|" ~ $.cache-root-dir ~ "|\nend" );
      $fh.say("# test_root_dir is deprecated");
      $fh.say("def test_root_dir\n\t%q|" ~ $.cache-root-dir ~ "|\nend" );
      $fh.say("def cache_dir\n\t%q|" ~ $.cache-dir ~ "|\nend" );
      $fh.say("def stdout_file\n\t%q|" ~ $stdout-file ~ "|\nend" );
      $fh.close;

      self!log("ruby glue deployed", "{$.cache-dir}/glue.rb");

  }

  method !run-ruby-task ($path) {

      self!log("run ruby task", $path);

      self!deploy-ruby-helpers($path);

      my $cmd = self!deploy-ruby-run-cmd($path);

      self!log("ruby task cmd deployed", $cmd);

      self.console-header("task run: {$path.IO.basename} - {self.name}");

      self.dump-code($path) if %*ENV<SP6_DUMP_TASK_CODE> and self.code-dumpable;

      self!run-command-async($cmd);

  }

  method !run-ruby-hook ($path) {

    self!log("run ruby hook", $path);

    self!deploy-ruby-helpers($path);

    my $cmd-path = self!deploy-ruby-run-cmd($path);

    self!log("ruby hook cmd deployed", $cmd-path );

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


