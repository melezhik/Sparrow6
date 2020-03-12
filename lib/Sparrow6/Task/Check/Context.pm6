#!perl6

use v6;

unit module Sparrow6::Task::Check::Context;

use Sparrow6::Common::Helpers;
use Sparrow6::Task::Check::Context::Common;

class Default

  does Sparrow6::Task::Check::Context::Common::Role
  does Sparrow6::Common::Helpers::Role

{


    has Array $.data;
    has Hash @.context is rw;
    has Array %.streams is rw;
    has Bool $.debug = %*ENV<SP6_DEBUG> ?? True !! False;
    has Str $.name = "default-context";

    method change-context (@data) {

      return

    }  

    method check-message ($l) { 

      "stdout match <$l>"

    }

}

class Sequence

  does Sparrow6::Task::Check::Context::Common::Role
  does Sparrow6::Common::Helpers::Role


{

    has Array $.data;
    has Hash @.context is rw;
    has Array %.streams is rw;
    has Bool $.debug = %*ENV<SP6_DEBUG> ?? True !! False;
    has Str $.name = "sequence-context";

    method change-context (@data) {

      my @new-context;
      my %new-streams;
      my $j=0;

      self!log("input context:", self.context.perl);

      for @data -> $i {

        my $stream-id;

        if $i<stream-id>:exists {
          $stream-id = $i<stream-id>;
        } else {
          $j++;
          $stream-id = $j;
          $i<stream-id> = $j;
        }

        my $next = $i<next>;

        if $next.defined  {
          my $data = self.data[$i<next>];
          push @new-context, %( data => $data, next => $i<next>+1, stream-id => $stream-id );
          self!log("push to a new context:", "{$data.perl} at index: {$i<next>}. next is: {$i<next>+1}");
        } 

        if self.streams{$stream-id}:exists {
          %new-streams{$stream-id} = self.streams{$stream-id};
          push %new-streams{$stream-id}, $i;
          self!log("update stream", $stream-id);
        } else {
          %new-streams{$stream-id} = [$i];
          self!log("new stream", $stream-id);
        }

      }

      self.streams = %new-streams;

      self!log("current stream",self.streams.keys.perl);
      self.context = @new-context;


      self!log("output context:", self.context.perl);

    }  

    method check-message ($l) { 

      "stdout match (s) <$l>"

    }

}

class Range

  does Sparrow6::Task::Check::Context::Common::Role
  does Sparrow6::Common::Helpers::Role

{


    has Array $.data;
    has Hash @.context is rw;
    has Array %.streams is rw;
    has Hash $.failed-streams is rw;
    has Str $.start is required;
    has Str $.end;
    has Bool $.debug = %*ENV<SP6_DEBUG> ?? True !! False;
    has Str $.name = "range-context";
 
    method TWEAK() {

      my @new-context;

      my $i = 0;

      my $stream-id = 0;

      if ! self.end.defined {

        for self.data -> $d {
          
          $i++;
  
          my $pattern = self.start;
  
          if $d ~~ /<$pattern>/ {
             $stream-id++;
             push self.context, %( data => $d, 'next' => $i, stream-id => $stream-id )
          }
  
        }
  
      } else {

        for self.data -> $d {
  
          my $pattern1 = self.start;
          my $pattern2 = self.end;
    
          $stream-id++ if $d ~~ /<$pattern1>/;
  
          if $d ~~ /<$pattern1>/ ^fff^ $d ~~ /<$pattern2>/ {
              push self.context, %( data => $d, 'next' => $i, stream-id => $stream-id )
          }
  
          $i++;
  
        }
  
      }


      self!log("start context:", self.context.perl);

    }  

    method change-context (@data) {

      my %succeed-streams;

      my %new-streams;

      for @data -> $i {

        my $stream-id = $i<stream-id>;

        if self.streams{$stream-id}:exists {
          %succeed-streams{$stream-id} = self.streams{$stream-id}; 
          push %succeed-streams{$stream-id}, $i;
          self!log("update succeed stream", $stream-id);
        } else {
          %succeed-streams{$stream-id} = [$i];
          self.streams{$stream-id} = [$i];
          self!log("new succeed stream", $stream-id);
        }


      }


      for self.streams.keys -> $stream-id {
        
          unless %succeed-streams{$stream-id}:exists {
            self!log("mark failed stream:", $stream-id);
            self.failed-streams{$stream-id} = 1              
          }
        
      }

      for %succeed-streams.keys -> $stream-id {

          unless self.failed-streams{$stream-id}:exists {
              %new-streams{$stream-id} = %succeed-streams{$stream-id}
          }
      }

      self.streams = %new-streams;

      self!log("current stream",self.streams.keys.perl);

    }  

    method mark-all-streams-as-failed () {


      for self.streams.keys -> $stream-id {
        
          unless self.failed-streams{$stream-id}:exists {
            self!log("mark failed stream:", $stream-id);
            self.failed-streams{$stream-id} = 1              
          }
        
      }

      self.streams = %();

    }

    method check-message ($l) { 

      "stdout match (r) <$l>"

    }

}
