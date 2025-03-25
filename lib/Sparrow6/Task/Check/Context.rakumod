#!raku

use v6;

unit module Sparrow6::Task::Check::Context;

use Sparrow6::Common::Helpers;
use Sparrow6::Task::Check::Context::Common;
use Data::Dump;

class Default

  does Sparrow6::Task::Check::Context::Common::Role
  does Sparrow6::Common::Helpers::Role

{


    has Array $.data;
    has Hash @.context is rw;
    has Array %.streams is rw;
    has Bool $.debug = %*ENV<SP6_DEBUG> ?? True !! False;
    has Str $.name = "default-context";
    has Bool $.just-started is rw = True;

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
    has Bool $.just-started is rw = True;

    method change-context (@data) {

      self.just-started = False;

      my @new-context;
      my %new-streams;
      my $j=0;

      self!log("input context:", Dump(self.context));

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
          my $data = self.data[$next];
          my $next_next = $next+1;
          if self.data[$next_next].defined {
            push @new-context, %( data => $data, next => $next_next, stream-id => $stream-id, index => $next );
            self!log("push to a new context:", "{$data.perl} at index: {$i<next>}. next is: {$next_next}");
          } else {
            push @new-context, %( data => $data, next => Nil, stream-id => $stream-id, index => $next );
            self!log("push to a new context:", "{$data.perl} at index: {$i<next>}. next is: <bottom>");
          }
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

      self!log("output context:", Dump(self.context));

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
    has Bool %.streams-keys is rw;
    has Hash $.failed-streams is rw;
    has Str $.start is required;
    has Str $.end;
    has Bool $.debug = %*ENV<SP6_DEBUG> ?? True !! False;
    has Bool $.streams-allowed is rw;
    has Str $.name = "range-context";
    has Int $.initial-streams-cnt is rw = 0;
    has Bool $.just-started is rw = True;
    has Bool $.zoom-mode is rw = False;
 
    method TWEAK() {

      self.streams-allowed = True;

      self!log("Start context", "Range") if %*ENV<SP6_DEBUG_TASK_CHECK>;
      
      my @new-context;

      my $i = 0;

      my $stream-id = 0;

      my %seen;

      my $flip-closed = False;
      
      my @group;

      if ! self.end.defined {
        
        my $pattern = self.start;
  
        self!log("Range pattern (within form)", "<$pattern>") if %*ENV<SP6_DEBUG_TASK_CHECK>;

        
        for self.data -> $d {
          
          $i++;
  
          if $pattern ~~ /^^ ":" (\d+) ":" $$/ {
              my $n = Int("{$0}");
              if $n == $i - 1 {
                 push self.context, %( data => $d, 'next' => $i, stream-id => $stream-id, index => $i - 1 );
                 last; 
              }
          } elsif $d ~~ /<$pattern>/ {
             $stream-id++;
             push self.context, %( data => $d, 'next' => $i, stream-id => $stream-id, index => $i - 1 );
          }
  
        }
  
      } else {

        my $start_ind = -1;
        my $stop_ind = -1;

        my $pattern1 = self.start;
        my $pattern2 = self.end;

        my $i = -1;

        if $pattern1 ~~ /":" (\d+) ":"/ {
            $start_ind = Int("{$0}");
        } 
        if $pattern2 ~~ /":" (\d+) ":"/ {
            $stop_ind = Int("{$0}");
        }

        self!log("Range pattern1", "<$pattern1>") if %*ENV<SP6_DEBUG_TASK_CHECK>;
        self!log("Range pattern2", "<$pattern2>") if %*ENV<SP6_DEBUG_TASK_CHECK>;

        for self.data -> $d {

          $i++;

          # boundary conditions  

          if $start_ind != -1 {
            $stream-id++ if $i == $start_ind;
          }  else {
            if $d ~~ /<$pattern1>/ {
               $stream-id++;
            } 
          }

          if $start_ind == -1 and $stop_ind == -1 and $d ~~ /<$pattern1>/ fff $d ~~ /<$pattern2>/ {
              self!log("Range", "cas1") if %*ENV<SP6_DEBUG_TASK_CHECK>;
              %seen{$stream-id} = "cas1_OK";
              push @group, %( data => $d, 'next' => $i, stream-id => $stream-id, index => $i );
              
              if $d ~~ /<$pattern1>/ {
                  @group = Array.new;
              }
              
              if $d ~~ /<$pattern2>/ {
                 for @group -> $j {
                   push self.context, $j;
                 }
                 @group = Array.new;
              }
              
              
              next;
          }

          if $start_ind != -1 and $stop_ind == -1 {
            self!log("Range", "cas2") if %*ENV<SP6_DEBUG_TASK_CHECK>;
            if $i >= $start_ind fff $d ~~ /<$pattern2>/ {
                next if $flip-closed;
                self!log("Range", "cas2_OK") if %*ENV<SP6_DEBUG_TASK_CHECK>;
                %seen{$stream-id} = "ok";
                push self.context, %( data => $d, 'next' => $i, stream-id => $stream-id, index => $i );
                $flip-closed = True if $d ~~ /<$pattern2>/
            }
            next;
          } 
          if $start_ind == -1 and $stop_ind != -1  {
            self!log("Range", "cas3") if %*ENV<SP6_DEBUG_TASK_CHECK>;
            if $d ~~ /<$pattern1>/ fff $i <= $stop_ind  {
                next if $flip-closed;
                self!log("Range", "cas3_OK") if %*ENV<SP6_DEBUG_TASK_CHECK>;
                %seen{$stream-id} = "ok";
                push self.context, %( data => $d, 'next' => $i, stream-id => $stream-id, index => $i );
                $flip-closed = True if $i == $stop_ind
            }
            next;
          } 
          if $start_ind != -1 and $stop_ind != -1 {
            self!log("Range", "cas4") if %*ENV<SP6_DEBUG_TASK_CHECK>;
            self!log("Range start_ind", $start_ind) if %*ENV<SP6_DEBUG_TASK_CHECK>;
            self!log("Range stop_ind", $stop_ind) if %*ENV<SP6_DEBUG_TASK_CHECK>;
            self!log("Range index", $i) if %*ENV<SP6_DEBUG_TASK_CHECK>;
            if $i >= $start_ind and $i <= $stop_ind  {
                self!log("Range", "cas4_OK") if %*ENV<SP6_DEBUG_TASK_CHECK>;
                %seen{$stream-id} = "ok";
                push self.context, %( data => $d, 'next' => $i, stream-id => $stream-id, index => $i );
            }
            next
          } 
  
        }
  
      }

      self.initial-streams-cnt = %seen.keys.elems;

      self!log("Initial context data", Dump(self.context)) if %*ENV<SP6_DEBUG_TASK_CHECK>;

      for self.context -> $i {
        self.streams-keys{$i<stream-id>} = True;
      }

      self!log("streams-keys", Dump(self.streams-keys)) if %*ENV<SP6_DEBUG_TASK_CHECK>;
    }  

    method change-context (@data) {

      my $time = time; 

      self.just-started = False;

      return if ! self.streams-allowed;

      my %succeed-streams;

      my %new-streams;

      for @data -> $i {

        my $stream-id = $i<stream-id>;

        if self.streams{$stream-id}:exists {
          %succeed-streams{$stream-id} = self.streams{$stream-id}; 
          #say  %succeed-streams{$stream-id}.raku;
          push %succeed-streams{$stream-id}, $i;
          self!log("update succeed stream", $stream-id) if %*ENV<SP6_DEBUG_STREAM>;
        } else {
          %succeed-streams{$stream-id} = [$i];
          self.streams{$stream-id} = [$i];
          self!log("new succeed stream", $stream-id) if %*ENV<SP6_DEBUG_STREAM>;
        }


      }


      for self.streams-keys.keys -> $stream-id {
        
          unless %succeed-streams{$stream-id}:exists {
            self!log("mark failed stream:", $stream-id) if %*ENV<SP6_DEBUG_STREAM>;
            self.failed-streams{$stream-id} = 1              
          }
        
      }

      for %succeed-streams.keys -> $stream-id {

          unless self.failed-streams{$stream-id}:exists {
              %new-streams{$stream-id} = %succeed-streams{$stream-id}
          }
      }

      self.streams = %new-streams;

      self!log("failed-streams",Dump(self.failed-streams)) if %*ENV<SP6_DEBUG_STREAM>;
      self!log("current stream",Dump(self.streams)) if %*ENV<SP6_DEBUG_STREAM>;
      my @new-context;
      for self.context -> $i {
        @new-context.push($i) if self.streams{$i<stream-id>}:exists;
      }
      self.context = @new-context;
      self!log("output context:", Dump(self.context));
      say "change-context last: {time - $time} sec" if %*ENV<SP6_PROFILE>;

    }  

    method disable-streams () {

      self.streams-allowed = False;

    }

    method check-message ($l) { 

      return self.end.defined ?? "stdout match (r) <$l>" !! "stdout match (w) <$l>"; 

    }

}
