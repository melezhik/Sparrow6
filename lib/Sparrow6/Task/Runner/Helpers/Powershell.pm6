#!perl6

unit module Sparrow6::Task::Runner::Helpers::Powershell;
use JSON::Tiny;

role Role {


  method !make-sparrow6-powershell-lib ($path) {

      mkdir $.cache-dir ~ '/sparrow6lib';

      my $fh = open $.cache-dir ~ '/sparrow6lib/sparrow6lib.psm1', :w;
      $fh.say(slurp %?RESOURCES<sparrow6lib.ps1>.Str);
      $fh.close;

      self!log("powershell lib deployed","{$.cache-dir}/sparrow6lib/sparrow6lib.psm1");

  }

  method !deploy-powershell-helpers ($path) {

      self!log("deploy powershell helpers","start");

      self!make-sparrow6-common-lib($path);

      self!make-powershell-glue($path);

      self!make-sparrow6-powershell-lib($path);

  }

  method !deploy-powershell-run-cmd ($path) {

      if $*DISTRO.is-win {

        self!log("powershell run cmd", "{$.cache-dir}/cmd.ps1");

        my $fh = open $.cache-dir ~ '/cmd.ps1', :w;

        $fh.say("\$env:PSModulePath = \$env:PSModulePath + \";{$.cache-dir}\"");
        $fh.say("\$global:ErrorActionPreference = \"Stop\"");
        $fh.say("Import-Module glue");
        $fh.say("Import-Module sparrow6lib");
        $fh.say(". $path");
        $fh.say("if ( \$lastexitcode -ne 0 ) \{");
        $fh.say("exit(\$lastexitcode)");
        $fh.say("}");   
        $fh.close;

        my $cmd = "powershell -NoLogo -NonInteractive -NoProfile {$.cache-dir}/cmd.ps1";

        self!log("powershell run cmd", $cmd);

        return $cmd;

      } else {

        my $cmd = "pwsh -NoLogo -NonInteractive -NoProfile -OutputFormat Text -c '\$global:ErrorActionPreference = \"Stop\";  Import-Module glue; Import-Module sparrow6lib; . $path'";

        my $fh = open $.cache-dir ~ '/cmd.bash', :w;

        $fh.say("set -e");
        $fh.say("export PSModulePath={$.cache-dir}:\$PSModulePath");
        $fh.say($cmd);
        $fh.close;

        self!log("powershell run cmd", $cmd);

        return "bash {$.cache-dir}/cmd.bash"

      }  

  }


  method !make-powershell-glue ($path) {

      my $stdout-file = $.cache-dir ~ '/stdout';

      if $stdout-file.IO ~~ :e {
        unlink $stdout-file;
        self!log("remove stdout file", $stdout-file);
      }

      mkdir $.cache-dir ~ '/glue/';

      my $fh = open $.cache-dir ~ '/glue/glue.psm1', :w;

      $fh.say('function root_dir {', "\n\t'", $.root.IO.absolute,"'\n}" );
      $fh.say('function os {', "\n\t'" , $.os , "'\n}" );
      $fh.say("# project_root_directory is deprecated");
      $fh.say('function project_root_dir {', "\n\t'" , $.root.IO.absolute , "'\n}" );
      $fh.say('function task_dir {', "\n\t'" , $path.IO.dirname.IO.absolute , "'\n}" );
      $fh.say('function cache_root_dir {', "\n\t'" , $.cache-root-dir , "'\n}" );
      $fh.say("# test_root_dir is deprecated");
      $fh.say('function test_root_dir {', "\n\t'" , $.cache-root-dir , "'\n}" );
      $fh.say('function cache_dir {', "\n\t'" , $.cache-dir , "'\n}" );
      $fh.say('function stdout_file {', "\n\t'" , $stdout-file , "'\n}" );
      $fh.close;

      self!log("powershell glue deployed", "{$.cache-dir}/glue/glue.psm1");

  }

  method !run-powershell-task ($path) {

      self!log("run powershell task", $path);

      self!deploy-powershell-helpers($path);

      my $cmd = self!deploy-powershell-run-cmd($path);

      self!log("powershell task cmd deployed", $cmd);

      self!run-bash-command-async($cmd);

  }

  method !run-powershell-hook ($path) {

    self!log("run powershell hook", $path);

    self!deploy-powershell-helpers($path);

    my $cmd-path = self!deploy-powershell-run-cmd($path);

    self!log("powershell hook cmd deployed", $cmd-path );

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


