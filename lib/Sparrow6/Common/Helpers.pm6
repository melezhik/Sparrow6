#!perl6

unit module Sparrow6::Common::Helpers;

my $timeformat = sub ($self) { sprintf "%02d:%02d:%02d %02d/%02d/%04d", .hour, .minute, .second,   .month, .day, .year given $self; };

role Role {

  method !log ($header, $message) {

    return unless $.debug;

    say "[debug::{self.name} $header] >>> [$message]";

  };

  method console ($message) {

    say "{DateTime.new(now, formatter => $timeformat)} [{$.name}] $message";

  };

}
