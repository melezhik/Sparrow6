#!perl6

unit module Sparrow6::Common::Helpers;

my $timeformat = sub ($self) { sprintf "%02d:%02d:%02d %02d/%02d/%04d", .hour, .minute, .second,   .month, .day, .year given $self; };
use Colorizable;

role Role {

  method !log ($header, $message) {

    return unless $.debug;

    say "[debug::{self.name} $header] >>> [$message]";

  };

  method console ($message) {

    my $header = "[{$.name}]" but Colorizable;
    my $ts = "{DateTime.new(now, formatter => $timeformat)}" but Colorizable;
    if %*ENV<SP6_FORMAT_TERSE> {
      say $message
    } elsif %*ENV<SP6_LOG_NO_TIMESTAMPS> {
      say %*ENV<SP6_FORMAT_COLOR> 
        ?? "{$header.colorize(:fg(magenta))} :: {$message}" 
        !! "$header :: {$message}";
    } else {
      say %*ENV<SP6_FORMAT_COLOR> 
        ?? "{$ts.colorize(:fg(magenta))} {$header.colorize(:fg(magenta))} :: {$message}" 
        !! "$ts $header :: {$message}";
    }

  };


  method !set-sparrow-root () {

    my $root;

    if $.sparrow-root {

      $root = %*ENV<SP6_PREFIX> ?? "{$.sparrow-root}/{%*ENV<SP6_PREFIX>}".IO.absolute  !! $.sparrow-root.IO.absolute;

      unless $root.IO ~~ :e {

        mkdir $root;

        self!log("sparrow root directory created", $root);

      }

      self!log("sparrow root directory choosen", $root);

    } else {

      if $*DISTRO.is-win {

        my $home = "{%*ENV<HOMEDRIVE>}{%*ENV<HOMEPATH>}";

        $root = %*ENV<SP6_PREFIX> ?? "{$home}/{%*ENV<SP6_PREFIX>}/sparrow6".IO.absolute !! "{$home}/sparrow6".IO.absolute;

        unless $root.IO ~~ :e {
          mkdir $root;
          self!log("sparrow root directory created", $root);
        }

      } elsif %*ENV<HOME> {

        $root = %*ENV<SP6_PREFIX> ?? "{%*ENV<HOME>}/{%*ENV<SP6_PREFIX>}/sparrow6".IO.absolute !! "{%*ENV<HOME>}/sparrow6".IO.absolute;

        unless $root.IO ~~ :e {
          mkdir $root;
          self!log("sparrow root directory created", $root);
        }

        self!log("sparrow root directory choosen", $root);

      } else {

        $root = %*ENV<SP6_PREFIX> ?? "/var/data/{%*ENV<SP6_PREFIX>}/sparrow6".IO.absolute !!  "/var/data/sparrow6".IO.absolute;

        unless $root.IO ~~ :e {
          mkdir $root;
          self!log("sparrow root directory created", $root);
        }

        self!log("sparrow root directory choosen", $root);

      }

    }

    # cache directory as an internal storage

    mkdir "{$root}/.cache";

    # directory with cli tasks

    mkdir "{$root}/tasks";

    self.sparrow-root = $root;

  }

  method !parse-run-params ( $thing is copy ) {

    my $what;

    my %params = Hash.new();

    if $thing ~~ /\S+/ && $thing ~~ /^^ (<- [ @ ] > ** 1..*) / {

      $what = "$0";

      self.console("run thing $what");

      if $thing ~~ /'@' ( .* )  $$/ {

        %params = "$0".split(",").map({ $_.split("=").flat }).flat;

        self!log("$what params",%params.perl);

      }

    } else {

      die "bad thing - $thing";

    }

    return $what, %params;

  }

}
