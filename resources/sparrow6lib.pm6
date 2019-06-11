#!perl6

use v6;

unit module sparrow6lib;

use JSON::Tiny;

use glue;

my $config;
my $variables;
my $captures;
my $streams;
my $streams_array;
my $matched;

sub set_stdout ($line) {

  my $fh = open(stdout_file()), :a;

  $fh.print("$line\n");

}

sub run_task ( $task, %vars? ) {

  say "task_var_json_begin";

  my $json = to-json( %vars || Hash.new );

  say $json;

  say "task_var_json_end";

  say "task: $task";


}

# this syntax is deprecated
# use `ignore_error` instead

sub ignore_task_error {
  say "ignore_task_error:";
}

sub ignore_error {
  say "ignore_error:";
}

sub config {

  return $config if $config.defined;

  $config = from-json slurp "{cache_root_dir()}/config.json";

  return $config;

}

sub variables {

  return $variables if $variables.defined;

  $variables = from-json slurp "{cache_dir()}/variables.json";

  return $variables;

}

sub task_var ($var) {
  variables(){$var};
}

sub matched {

  return $matched if $matched.defined;

  $matched = "{cache_root_dir()}/matched.txt".IO.lines;

  return $matched;

}

sub captures {

  return $captures if $captures.defined;

  my @json = from-json slurp "{cache_root_dir()}/captures.json";

  $captures = @json.map({ $_<data> });

  return $captures;

}


sub capture {
  captures()[0];
}

sub streams {

  return $streams if $streams.defined;

  $streams = from-json slurp "{cache_root_dir()}/streams.json";

  return $streams;

}

sub streams_array {

  return $streams_array if $streams_array.defined;

  $streams_array = from-json slurp "{cache_root_dir()}/streams-array.json";

  return $streams_array;

}

sub dump_streams {

  my @streams = streams_array();

  my $s = 0;

  for @streams -> $str {
      $s++;
      say "stream: $s";
      my $l = 0;
      for $str -> $layer {
        $l++;
        say "\tlayer: $l";
        say "\t\t", $layer.join(" ");
      }
  }

}

sub get_state {

  my $state = from-json slurp "{cache_dir_root()}/state.json";

  return $state;

}

sub update_state (%state) {

  spurt "{cache_root_dir()}/state.json", to-json(%state);

  return;

}

1;

