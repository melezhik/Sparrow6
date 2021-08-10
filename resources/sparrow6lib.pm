
package sparrow6lib;

1;

package main;

use strict;

use JSON::PP qw{encode_json};
use Carp qw/confess/;

use glue;

my $config;
my $variables;
my $captures;
my $streams;
my $streams_array;
my $matched;

sub set_stdout {
  my $line = shift;
  open my $fh, ">>", stdout_file() or die "can't open ".(stdout_file())." to write: $!";
  print $fh $line, "\n";
  close $fh;
}

sub run_task {

  my $task = shift;

  my $vars = shift || {};

  print "task_var_json_begin\n";

  my $json = encode_json($vars);

  print "$json\n";

  print "task_var_json_end\n";


  print "task: $task\n";


}

# this syntax is deprecated
# use `ignore_error` instead

sub ignore_task_error {
  print "ignore_task_error:\n";
}

sub ignore_error {
  print "ignore_error:\n";
}

sub ignore_task_check_error {
  print "ignore_task_check_error:\n";
}

sub config {


  return $config if $config;

  my $path =  cache_root_dir()."/config.json";

  open(my $fh, $path) or confess "can't open file $path to read: $!";
  my $data = join "", <$fh>;
  close $fh;

  my $json = JSON::PP->new;
  $config = $json->decode($data);

  return $config;

}

sub variables {

  return $variables if $variables;

  my $path =  cache_dir()."/variables.json";

  open(my $fh, $path) or confess "can't open file $path to read: $!";
  my $data = join "", <$fh>;
  close $fh;

  my $json = JSON::PP->new;
  $variables = $json->decode($data);

  return $variables;

}

sub task_var {
  my $var = shift;
  variables()->{$var};
}

sub matched {


  return $matched if $matched;

  my $path =  cache_root_dir()."/matched.txt";

  open(my $fh, $path) or confess "can't open file $path to read: $!";
  while (my $l = <$fh>){
    chomp $l;
    push @$matched, $l;
  };
  close $fh;

  return $matched;

}

sub captures {


  return $captures if $captures;

  my $path =  cache_root_dir()."/captures.json";

  open(my $fh, $path) or confess "can't open file $path to read: $!";
  my $data = join "", <$fh>;
  close $fh;

  my $json = JSON::PP->new;

  $captures = [ map { $_->{data} } @{$json->decode($data)} ];

  return $captures;

}


sub capture {
  captures()->[0];
}

sub streams {

  return $streams if $streams;

  my $path =  cache_root_dir()."/streams.json";

  open(my $fh, $path) or confess "can't open file $path to read: $!";
  my $data = join "", <$fh>;
  close $fh;

  my $json = JSON::PP->new;

  $streams = $json->decode($data);

  return $streams;

}

sub streams_array {

  return $streams_array if $streams_array;

  my $path =  cache_root_dir()."/streams-array.json";

  open(my $fh, $path) or confess "can't open file $path to read: $!";
  my $data = join "", <$fh>;
  close $fh;

  my $json = JSON::PP->new;

  $streams_array = $json->decode($data);

  return $streams_array;

}

sub dump_streams {

  my @streams = @{streams_array()};

  my $s = 0;

  for my $str (@streams) {
      $s++;
      print "stream: $s\n";
      my $l = 0;
      for my $layer (@{$str}){
        $l++;
        print "\tlayer: $l\n";
        print "\t\t", (join " ", @{$layer}), "\n";
      }
  }
}

sub get_state {

  my $path =  cache_root_dir()."/state.json";

  open(my $fh, $path) or confess "can't open file $path to read: $!";
  my $data = join "", <$fh>;
  close $fh;

  my $json = JSON::PP->new;

  my $state = $json->decode($data);

  return $state;

}

sub update_state {

  my $path =  cache_root_dir()."/state.json";

  my $state = shift;

  my $json = JSON::PP->new;

  my $state_json = $json->encode($state);

  open(my $fh, ">", $path) or confess "can't open file $path to write: $!";

  print $fh $state_json;

  close $fh;

  return;

}

1;

