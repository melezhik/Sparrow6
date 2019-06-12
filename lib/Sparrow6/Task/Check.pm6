#!perl6

use v6;

unit module Sparrow6::Task::Check;

use Sparrow6::Common::Helpers;
use Sparrow6::Task::Check::Context;

use JSON::Tiny;

class Api 

  does Sparrow6::Common::Helpers::Role

  {

  has @.results;
  has @.succeeded;
  has @.captures;
  has Str $.last-match-line;
  has Bool $.last-check-status;
  has Int $.check-max-len = 40;
  has Array $.data is rw;
  has %.languages;
  has Str  $.name = "task-check";
  has Str  $.cache-root-dir is rw;
  has Str  $.parent-task-root-dir;
  has Bool $.debug = %*ENV<SP6_DEBUG> ?? True !! False;
  has $.tr;
  has $.current-context is rw;

  method TWEAK() {

    self.current-context = Sparrow6::Task::Check::Context::Default.new( data => self.data );

  }

  method captures {
    @!captures;
  }

  method !add-note ( $message ) {
    @!results.push: %( type => 'note', message => $message );
  }

  method !add-result ( %item ) {
    %item<type> = 'check-expression';
    @!results.push: %item;
  }

  method !run-code (Str $code is copy) { 

    my %lang-to-extension = %(
      perl => 'pl',
      bash => 'bash',
      ruby => "rb",
      python => "py"
    );

    my $language = "perl"; # default language

    if $code ~~ s/^^ \s* '!' (\w+) \s* $$// {
        $language = $0;
        self!log("code set language", $language);
    }

    die "language $language not supported for task checks" unless %lang-to-extension{$language}:exists;

    my $cache-root-dir = self.cache-root-dir;

    mkdir "{$cache-root-dir}/.checks/";

    spurt "{$cache-root-dir}/.checks/task.{ %lang-to-extension{$language}}", $code;

    self!log("code run language", $language);

    my @orig-stdout-data = self.tr.stdout-data;
    my @orig-stderr-data = self.tr.stderr-data;

    self.tr.keep-cache = True;
    self.tr.silent = True;
    self.tr.name = "task-check";
    self.tr.task = "{$cache-root-dir}/.checks/";

    if "{self.parent-task-root-dir}/common.rb".IO ~~ :e {
      copy("{self.parent-task-root-dir}/common.rb","{$cache-root-dir}/.checks/common.rb");
    }

    if "{self.parent-task-root-dir}/common.bash".IO ~~ :e {
      copy("{self.parent-task-root-dir}/common.bash","{$cache-root-dir}/.checks/common.bash");
    }

    self.tr.task-run();

    self!log("code return", self.tr.stdout-data.perl);

    my @r;

    for self.tr.stdout-data -> $i {
      push @r, $i;
    }

    self.tr.stdout-data = @orig-stdout-data;
    self.tr.stderr-data = @orig-stderr-data;

    return @r;
  
  }

  method !handle-code ($code) { 
    for self!run-code($code) -> $i {
      @!results.push: %( type => 'note', message => $i );
    }
  }

  method !handle-generator ($code) { self.validate((self!run-code($code))) }

  method !handle-plain (Str $line) {
    self!handle-simple($line, 'default');
  }

  method !handle-regexp (Str $line) {
    self!handle-simple($line, 'regexp');
  }

  method !handle-simple (Str $l is copy, Str $check-type) {
  
    # remove spaces in the beginning and in the end
    $l ~~ s/ \s+ $$ //;
    $l ~~ s/^^ \s+//;

    self!check-line($l, $check-type, self.current-context.check-message($l));
  
    self!log("$check-type check DONE", $l);

  }

  method !check-line ( Str $pattern, Str $check-type, Str $message ) {

    my $status = False;

    my @captures = Array.new;

    self!log("lookup pattern", $pattern);

    @!succeeded = Array.new;

    my @new-context;

    if $check-type eq 'default' {

        for self.current-context.context -> $ln {

            my $st = index($ln<data>,$pattern);

            if $st.defined {
                $status = True;
                $!last-match-line = $ln<data>;
                @!succeeded.push: $ln<data>;
                $ln<captures> = [ $ln<data> ]; 
                push @new-context, $ln;
                @captures.push:  %( stream-id => $ln<stream-id>, data => [ $ln<data> ] ) ;
            }
            
        }
    } elsif $check-type eq 'regexp' {

        for self.current-context.context -> $ln {

           my $matched = $ln<data>.comb(/<mymatch=$pattern>/,:match)>>.<mymatch>;
 
           if $matched {

                $status = True;

                if $matched>>.Slip>>.Str {
                  my @c = $matched>>.Slip>>.Str;
                  @captures.push:  %( stream-id => $ln<stream-id>, data => [ @c ] );
                  $ln<captures> = [ @c ]; 
                } else {
                  @captures.push: %( stream-id => $ln<stream-id>, data => [ $ln<data> ] );
                  $ln<captures> = [ $ln<data> ]; 
                }

              @!succeeded.push: $ln<data>;
              $!last-match-line = $ln<data>;
              push @new-context, $ln;
          }
        }
    }else {
        die "unknown check type: $check-type";
    }

    $!last-check-status = $status;

    self.current-context.change-context(@new-context) if @new-context;

    if $.debug {
        say "STATUS:",  $status.perl;
        say "CAPTURES:", @captures.perl;
        say "MATCHED:",  @!succeeded.perl;
    }

    @!captures = @captures;

    spurt $.cache-root-dir ~ '/matched.txt', join "\n", @!succeeded;

    self!log("MATCHED saved", $.cache-root-dir ~ '/matched.txt' );

    spurt $.cache-root-dir ~ '/captures.json', to-json(@!captures);

    self!log("CAPTURES saved", $.cache-root-dir ~ '/captures.json' );

    spurt $.cache-root-dir ~ '/streams.json', to-json(self.current-context.streams);

    self!log("STREAMS hash saved", $.cache-root-dir ~ '/streams.json' );

    spurt $.cache-root-dir ~ '/streams-array.json', to-json(self.current-context.streams-as-array);

    self!log("STREAMS array saved", $.cache-root-dir ~ '/streams-array.json' );

    self!add-result({ status => $status , message => $message });

    return $status;
  }
    
  method validate (@check-list) {

    my $block-type;
    my @multiline-block = Array.new;
    my $here-str-mode = False;
    my $here-str-marker;

    LINE: for @check-list -> $ll {

        my $l = $ll.chomp;

        self!log("parse item", ($block-type || 'LINE') ~ '@' ~ $l );

        unless $here-str-mode { # don't strip comments and blank lines in here-string mode

          next LINE unless $l ~~ / \S /;    # skip blank lines
  
          next LINE if $l ~~ / ^^ \s* '#' .* /;  # skip comments
  
          $l ~~ s/'#'.*//; # remove comments parts for strings like "something # comment"
  
          
          if $l ~~ / ^^ \s* 'note:' \s* (.*) $$ /  {
             self!add-note("$0");
             next;
          }
   
        }
 
        if $here-str-mode && $l ~~ s/ ^^ \s* $here-str-marker \s* $$ // {

          $here-str-mode = False; 

          self!log("here string mode", "off");

          self!flush-multiline-block( $block-type, @multiline-block) if $block-type;

        } elsif $here-str-mode  { # multiline block

           # this is multiline block as here string, 
           # accumulate lines until here string end marker
  
           self!log("push $l to block", $block-type);

           @multiline-block.push: $l;

        } elsif $l ~~ / ^^ \s* 'within:' \s+  (.*?)  \s*  $$ / {

          my $start = "$0";

          if self.current-context.^name eq "Sparrow6::Task::Check::Context::Default" {
            self.current-context = Sparrow6::Task::Check::Context::Within.new( data => self.data, start => $start );
          } else {
            die "nested contexts are forbidden";
          }

      
        } elsif $l ~~ / ^^ \s* 'between:' \s+ '{' (.*?) '}' \s+ '{' (.*?) '}'  $$ / {

          die "nested contexts are forbidden" unless self.current-context.^name eq "Sparrow6::Task::Check::Context::Default";

          self.current-context = Sparrow6::Task::Check::Context::Range.new( data => self.data, start => "$0", end => "$1"  );

        } elsif $l ~~ / ^^ \s* 'begin:' \s* $$ / {
                    
          die "nested contexts are forbidden" unless self.current-context.^name eq "Sparrow6::Task::Check::Context::Default";

          self.current-context = Sparrow6::Task::Check::Context::Sequence.new( data => self.data );

        } elsif $l ~~ / ^^ \s* 'end:' \s* $$ / {
                    
          self.current-context = Sparrow6::Task::Check::Context::Default.new( data => self.data );

        } elsif $l ~~ / ^^ \s* 'assert:' \s+ (True|true|False|false|0|1) \s+ (.*)/ {

            my $status-string = "$0"; my $message = $1;

            self!log("assert found", "status: $status-string | message: $message");

            my $status = $status-string.Int.Bool; # from int conversion

            $status = False if $status-string eq 'false'; # from ruby conversion

            $status = True if $status-string eq 'true';  # from ruby conversion

            $status = False if $status-string eq 'False'; # from python/perl6/powershell conversion

            $status = True if $status-string eq 'True';  # form python/perl6/powershell conversion

            self!add-result({ status => $status , message => "<$message>" });

        } elsif $l ~~  /^^ \s* ( 'code' | 'generator' ) ':' \s* (.*) /  {

            my $my-block-type = $0;

            self!flush-multiline-block( $block-type, @multiline-block) if $block-type;

            my $code = $1;

            if $code ~~ s/'<<' (\S+) // {

                $block-type = $my-block-type;

                $here-str-mode = True;

                $here-str-marker = $0;

                self!log("$block-type block start. heredoc marker", $here-str-marker);

            } else {

                self!log("one-line $my-block-type found", $code);

                self!flush-multiline-block( $block-type, @multiline-block) if $block-type;

                self!"handle-$my-block-type"($code.Str);

            }
        } elsif $l ~~ /^^ \s* 'regexp:' \s* (.*) / { # `regexp' line

            my $re = $0;

            self!handle-regexp($re.Str);

        } else { # `plain string' line

            $l ~~ s/\s+\#.*//; 

            $l ~~ s/^\s+//;

            self!handle-plain($l);
        }
    }

  
  }

  method  !flush-multiline-block ($block-type is rw, @multiline-block) {

    my $name = "handle-" ~ $block-type; 

    self!log("block end",$block-type);

    self!"$name"(@multiline-block.join("\n"));
  
    # flush mulitline block data:

    $block-type = Nil;

    @multiline-block = Array.new;

  }
}
