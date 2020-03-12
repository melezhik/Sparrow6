#!perl6

use v6;

unit module Sparrow6::Task::Check::Context::Common;

role Role {

    method TWEAK() {
      # one directional linked list 
      for 1 .. $.data.elems  -> $i {
        if $i < $.data.elems {
          push self.context, %( data => $.data[$i-1], 'next' => $i )
        } else {
          push self.context, %( data => $.data[$i-1], 'next' => Nil )
        }
      }

      self!log("start context:", self.context.perl);

    }

    method streams-as-array () {

      my @list;

      for self.streams.keys.sort(+*) -> $s {
        push @list, self.streams{$s}.map({ $_<captures>})
      }

      return @list;
    }
}
