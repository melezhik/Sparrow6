#!perl6

unit module Sparrow6::Task::Runner::Helpers::Perl6;
use JSON::Tiny;

role Role {

  method !make-sparrow6-perl6-lib ($path) {

      my $fh = open $.cache-dir ~ '/sparrow6lib.pm', :w;
      $fh.say(slurp %?RESOURCES<sparrow6lib.pm6>.Str);
      $fh.close;

      self!log("perl6 lib deployed","{$.cache-dir}/sparrow6lib.pm");

  }

  method !deploy-perl6-helpers ($path) {

      self!log("deploy perl6 helpers","start");

      self!make-sparrow6-common-lib($path);

      self!make-perl6-glue($path);

      self!make-sparrow6-perl6-lib($path);

  }

  method !deploy-perl6-run-cmd ($path) {

      unlink "{$.root}/lib/.precomp" if "{$.root}/lib/.precomp".IO ~~ :d;

      my $cmd = "perl6 -I {$.cache-dir} -I {$.root}/lib -Mglue -Msparrow6lib $path";

      self!log("perl6 run cmd", $cmd);

      my $fh = open $.cache-dir ~ '/cmd.bash', :w;
      $fh.say("set -e");
      $fh.say($cmd);
      $fh.close;

      return $.cache-dir ~ '/cmd.bash'
  }


  method !make-perl6-glue ($path) {

      my $stdout-file = $.cache-dir ~ '/stdout';

      if $stdout-file.IO ~~ :e {
        unlink $stdout-file;
        self!log("remove stdout file", $stdout-file);
      }

      my $fh = open $.cache-dir ~ '/glue.pm6', :w;
      $fh.say("unit module glue;");
      $fh.say('sub root_dir () is export { qq{' ~ $.root.IO.absolute ~ "} };" );
      $fh.say('sub os () is export { qq{' ~ $.os ~ "} };" );
      $fh.say("# project_root_directory is deprecated");
      $fh.say('sub project_root_dir () is export { qq{' ~ $.root.IO.absolute ~ "} };" );
      $fh.say('sub task_dir () is export { qq{', $path.IO.dirname.IO.absolute, "} };");
      $fh.say('sub cache_root_dir () is export { qq{', $.cache-root-dir, "} };");
      $fh.say("# test_root_dir is deprecated");
      $fh.say('sub test_root_dir () is export { qq{', $.cache-root-dir, "} };");
      $fh.say('sub cache_dir () is export { qq{', $.cache-dir, "} };");
      $fh.say('sub stdout_file () is export { qq{', $stdout-file, "} };");
      $fh.close;

      self!log("perl6 glue deployed", "{$.cache-dir}/glue.pm");

  }

  method !run-perl6-task ($path) {

      self!log("run perl6 task", $path);

      self!deploy-perl6-helpers($path);

      my $cmd = self!deploy-perl6-run-cmd($path);

      self!log("perl6 task cmd deployed", $cmd);

      self!run-bash-command-async($cmd);


  }

  method !run-perl6-hook ($path) {

    self!log("run perl6 hook", $path);

    self!deploy-perl6-helpers($path);

    my $cmd-path = self!deploy-perl6-run-cmd($path);

    self!log("perl6 hook cmd deployed", $cmd-path );

    my $bash-cmd = self!bash-command($cmd-path);

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


