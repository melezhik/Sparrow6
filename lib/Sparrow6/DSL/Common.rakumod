use v6;

unit module Sparrow6::DSL::Common;

use Sparrow6::Task::Repository;
use Sparrow6::Task::Runner;

multi sub task-run(Str $desc, Str $plugin, %parameters = %()) is export(:DEFAULT) {

    my $sph-api = Sparrow6::Task::Repository::Api.new();

    $sph-api.plugin-install($plugin);

    my $runner = Sparrow6::Task::Runner::Api.new(
      name  => $desc,
      root  => $sph-api.plugin-directory($plugin),
      do-test => False,
      show-test-result => True,
      parameters => %parameters
    );


    $runner.task-run;

}

multi sub task-run() is export(:DEFAULT) {
  task-run("{$*CWD}");
}

multi sub task-run(Str $path, %parameters = %()) is export(:DEFAULT) {

    my $sph-api = Sparrow6::Task::Repository::Api.new();

    my ($root, $task) = $path.split(/'@'/);

    $sph-api.install-plugin-deps($path);

    my $task-name;

    if  %*ENV<SP6_TASK_ROOT> {
      if $root.IO !~~ :d &&  "{%*ENV<SP6_TASK_ROOT>}/$root".IO ~~ :d  {
         $root = "{%*ENV<SP6_TASK_ROOT>}/$root";
         $task-name = "::{$path}"
      } else {
        $task-name = $path
      }
    } else {
      $task-name = $path
    }

    if $task {

      my $runner = Sparrow6::Task::Runner::Api.new(
        name  => $task-name,
        root  => $root,
        task =>  $task,
        do-test => False,
        show-test-result => True,
        parameters => %parameters
      );

      $runner.task-run;

    } else {

      my $runner = Sparrow6::Task::Runner::Api.new(
        name  => $task-name,
        root  => $root,
        do-test => False,
        show-test-result => True,
        parameters => %parameters
      );
  
      $runner.task-run;

    }

}

sub module-run($name, %args = %()) is export(:DEFAULT) {

  if ( $name ~~ /(\S+)\@(.*)/ ) {
      my $mod-name = $0; my $params = $1;
      my %mod-args;
      for split(/\,/,$params) -> $p { %mod-args{$0.Str} = $1.Str if $p ~~ /(\S+?)\=(.*)/ };
      require ::('Sparrow6::' ~ $mod-name); 
      ::('Sparrow6::' ~ $mod-name ~ '::&tasks')(%mod-args);
  } else {
      require ::('Sparrow6::' ~ $name); 
      ::('Sparrow6::' ~ $name ~ '::&tasks')(%args);
  }

}

# Following functions
# Are deprecated
# And added for back compatibility reasons
# Eventually I'll get rid of them

multi sub task-run(%args) is export { 
  task-run(%args<task>, %args<plugin>, %args<parameters>); 
}

multi sub task_run($desc, $plugin, %parameters?) is export { 
  task-run($desc, $plugin, %parameters); 
}

multi sub task_run(%args) is export { 
  task-run(%args<task>, %args<plugin>, %args<parameters>); 
}


sub tags (:$array = False) is export(:DEFAULT) {
  %*ENV<SP6_TAGS> ?? parse-tags(%*ENV<SP6_TAGS>,:array($array)) !! %();
}

sub parse-tags ($tags,:$array = False) is export(:DEFAULT) {
  my %tags = %();
  for $tags.split(",") -> $i {
    my $pair = $i;
    say "tag>> parse pair: $pair" if %*ENV<SP6_TAG_DEBUG>;
    # decode string if it's in base64
    say "tag>> effective pair: $pair" if %*ENV<SP6_TAG_DEBUG>;
    if $pair ~~ /(\S+) '=' (.*) $$/ {
      my $var = "$0";
      my $val = "$1".
        subst(/"___comma___"/,",",:g).
        subst(/"___eq___"/,"=",:g);
      # subsitute anything like
      # .env[a]
      # by %*ENV<a>  
      my @env;
      for $val ~~ m:g/".env[" (\w+) "]"/ -> $e {
        push @env, "{$e[0]}";
      }
      for @env -> $e {
        $val.=subst(".env[$e]",%*ENV{$e},:g);
      }
      if %tags{$var} && $array { # array support 
        if %tags{$var}.isa(List) {
           say "tag>> append to list $var.append[$val]" if %*ENV<SP6_TAG_DEBUG>;
           %tags{$var}.push($val) # append to Array
        } else {
          say "tag>> set list $var=[%tags{$var}, $val]" if %*ENV<SP6_TAG_DEBUG>;
          %tags{$var} = [ %tags{$var}, $val ] # convert `foo=1,foo=2,..` into Array
        } 
      } else {
        say "tag>> scalar $var=$val" if %*ENV<SP6_TAG_DEBUG>;
        %tags{$var} = $val;
      }
   } else {
      %tags{$pair} = True
   }
  }

  %tags;

}
