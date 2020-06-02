#!perl6

unit module Sparrow6::Task::Runner::Helpers::Common;

use JSON::Tiny;

role Role {

  method !test-log ($header, $message) {

    say "[$header] >>> [$message]";

  };

  method !check-log ($header, $message) {

    say "[$header] $message";

  };

  method !make-sparrow6-common-lib ($path) {

    my $fh = open $.cache-dir ~ '/sparrow6common.pm6', :w;
    $fh.say(slurp %?RESOURCES<sparrow6common.pm6>.Str);
    $fh.close;

    self!log("common lib deployed", "{$.cache-dir}/sparrow6common.pm6");

  }

  method !save-task-vars ($path) {

      my $vars = self.task-vars;

      my $fh = open "$path/variables.json", :w;
      $fh.say(to-json($vars));
      $fh.close;

      self!log("deploy task vars",$vars.perl);

      self!log("task vars deployed as json","$path/variables.json");

      $fh = open "$path/variables.bash", :w;

      for $vars.keys -> $name {
        $fh.say("$name=\"{$vars{$name}}\"");
      }
      $fh.close;

      self!log("task vars deployed as bash", "$path/variables.bash");

  }


  method !process-stdout-from-hook ($path) {

    # read hook's stdout if any
    # see set-stdout function

    my $stdout-file = $.cache-dir ~ '/stdout';

    if "$stdout-file".IO ~~ :e {

      self!log("read stdout from", $stdout-file);

      for $stdout-file.IO.lines -> $line {
        self!log("set stdout",$line);
        push self.stdout-data, $line;
        self.console($line);
      }

    }
  }

  method !erase-stdout-data () {
    self.stdout-data = Array.new;
    self.stderr-data = Array.new;
  }


  method !run-command ($cmd) {

    my @arr = $cmd.split(/\s+/);
    self!log("effective command", @arr);
    return run @arr, :out, :err;
  
  }


  method !run-command-async ($cmd) {

    my $proc;

    my @arr = $cmd.split(/\s+/);

    self!log("effective command", @arr);

    $proc = Proc::Async.new(@arr);

    ($*OUT,$*ERR).map: {.out-buffer = 0};

    react {

        whenever $proc.stdout.lines { # split input on \r\n, \n, and \r 

          my $line = chomp($_);

          my $stdout-lines = 0;

          self.console($line) unless self.silent-stdout;
          push self.stdout-data, $line;

          #say ‘line: ’, $_

        }

        whenever $proc.stderr { # chunks 

          my $line = chomp($_);

          push self.stderr-data, $line;
          self.console("stderr: $line"); # unless self.silent-stderr;

          # say ‘stderr: ’, $_

        }

        whenever $proc.ready {
            #say ‘PID: ’, $_ # Only in Rakudo 2018.04 and newer, otherwise Nil 
        }

        whenever $proc.start {

            #say ‘Proc finished: exitcode=’, .exitcode, ‘ signal=’, .signal;

            unless self.silent-stdout {
              self.console("<empty stdout>") if self.stdout-data.elems == 0;
            }
  

            my $exit-code = .exitcode;

            if $exit-code != 0 and ! $.ignore-task-error {
              self.console("task exit status: $exit-code");
              self.console("task {self.name} FAILED");
              exit($exit-code);
            }


            # reset ignore-task-error
            self.ignore-task-error = False;

            done # gracefully jump from the react block

        }
    }

    return

  }


  method !handle-task-status ($cmd) {
  
    my $st = $cmd.status;

    $cmd.out.close().^name; # we don't want to sink here

    if $st != 0 and ! $.ignore-task-error {
      self.console("task exit status: $st");
      self.console("task {self.name} FAILED");
      exit(100);
    }

    # reset ignore-task-error
    self.ignore-task-error = False;

  }

  method !handle-hook-status ($cmd) {
  
    my $st = $cmd.status;

    if $st != 0 {
      self.console("hook exit status: $st");
      self.console("hook {self.name} FAILED");
      for $cmd.err.lines -> $line {
        self.console("stderr: $line");
      }
      for $cmd.out.lines -> $line {
        self.console("stdout: $line");
      }
      $cmd.out.close().^name; # we don't want to sink here
      exit(101);
    } else {
      $cmd.out.close();
    }

  }


  method !capture-cmd-output ($cmd, %args?) {

    unless %args<ignore-stderr> {
      for $cmd.err.lines -> $line {
        push self.stderr-data, $line;
        self.console("stderr: $line") unless self.silent-stderr;
      }
    }

    my $stdout-lines = 0;

    for $cmd.out.lines -> $line {
      self.console($line) unless self.silent-stdout;
      push self.stdout-data, $line;
      $stdout-lines++;
    }

    unless self.silent-stdout {
      self.console("<empty stdout>") if $stdout-lines == 0;
    }

  }


  method !get-state {

    my %data = Hash.new;

    if "{$.cache-root-dir}/state.json".IO ~~ :e {
        self!log("state returned", "{$.cache-root-dir}/state.json");
        %data = from-json(slurp "{$.cache-root-dir}/state.json")
    } else {
        self!log("no state returned", "{$.cache-root-dir}/state.json");
    }

    return %data;
  }

}

