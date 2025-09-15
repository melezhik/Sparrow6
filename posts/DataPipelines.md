# Data pipelines with Rakulang and Sparky

After one Rakulang community member and bio informatics developer  mentioned the [Nexflow](ttps://nextflow.io) data pipeline framework, I was surprised that Sparky and Sparrow6 eco system could be a good fit for such a type of tasks.

Reasons:

* Tasks and scripts are already first class citizens in Sparrow6 core

* Parallelism and HPC is already implemented via Sparky Job API and running Sparky in cluster mode

So it took me less then hour to create this [POC](https://github.com/melezhik/mixing-script-langauges/tree/main) 
of porting some [example](https://nextflow.io/mixing-scripting-languages.html) Nextflow pipeline to Sparky

# Pipeline example

The example is taken from Nextflow web site as is - 

> With Nextflow, you are not limited to Bash scripts -- you can use any scripting language! 
> In other words, for each process you can use the language that best fits the specific task or that you simply prefer.
> In the above example we define a simple pipeline with two processes.
> The first process executes a Perl script ... the second process will execute a Python script

Apparently two scripts exchanges data between each other via so called Nextflow channel. The first Perl script produces
array of rational number, the second one Python makes some average calculation upon them.

In Sparky, Sparrow world it all boils down to this simple pipeline code:

```raku
#!raku
use Sparky::JobApi;

class Pipeline

  does Sparky::JobApi::Role

  {

    method stage-main {

      my $j = self.new-job;

      my %s = task-run "files/tasks/perl";
  
      say %s<lines>.raku;

      $j.put-stash(%s);

      $j.queue({
        description => "python job", 
        tags => %(
          stage => "child",
        ),
        sparrowdo => %(:no_index_update),
      });

      # wait python job
      my $st = self.wait-job($j);
      die unless $st<OK>;
  
    } 

    method stage-child {

      say "I am a child scenario";
      say "tags: ", tags().raku;
      my $j = Sparky::JobApi.new(:mine);
      my $state = $j.get-stash();

      directory "scm";

      git-scm 'https://github.com/melezhik/mixing-script-langauges.git', %(
        :to<scm>,
        :branch<main>,
      );

      task-run "scm/files/tasks/python", %(
        :lines($state<lines>),
      ),
  }

}

Pipeline.new.run;
```

## Explanation

First job tagged as "main" executes Perl task `my %s = task-run "files/tasks/perl"` and save result to Raku variable (%s Hash map), 
then the second child job gets launched (in general on separate Sparky instance if run in cluster mode), 
this second job runs Python task (`task-run "scm/files/tasks/python"`) that performs some calculation upon initial data. 
The task takes input data produced by the first Perl task which is just an array of rational numbers and calculate an average.

The input data gets passed via two jobs using so called stash mechanism 
(implemented by Sparky) - `$j.put-stash(%s), $j.get-stash()`

Perl and Python tasks are just plain scripts residing inside files/tasks directory:

- https://github.com/melezhik/mixing-script-langauges/blob/main/files/tasks/perl/task.pl - Perl task

```perl
use strict;
use warnings;

my $count;

my $range = config()->{range};

my @lines;
for ($count = 0; $count < 10; $count++) {
  push @lines, rand($range) . ', ' . rand($range);
}

print join "\n", @lines;

update_state({ lines => \@lines });
```

- https://github.com/melezhik/mixing-script-langauges/blob/main/files/tasks/python/task.py - Python

```python
from sparrow6lib import *

x = 0
y = 0
lines = 0
for line in config()['lines']:
  items = line.strip().split(",")
  x += float(items[0])
  y += float(items[1])
  lines += 1
print("avg: %s - %s" % ( x/lines, y/lines ))
```

## Nextflow vs Sparky

* Because Sparrow provides all useful primitives to work with tasks, tasks development is extremely convenient (
passing input data and returning output data is already implemented for example), unlike in Nextflow scripts are not
inlined into main pipeline code and thus are easier to maintain and debug, because data flow logic and scripts logic is separated.

* Also unlike in Nextflow, in Sparky there is no channel mechanism, data gets passed to or from scripts via normal Raku function calls (task-run), make code more readable and easier to debug. When data needs to be passed across jobs (and possible across different Sparky instances Sparky Job Api protocol ensures that via normal http transport).

## UI

As bonus all pipeline steps execution are visible via UI reports, thanks to nice and clean Sparky UI:

![child-job.jpeg](https://github.com/melezhik/mixing-script-langauges/blob/main/screenshots/main-job.jpeg)


## Conclusion

This is very simple POC, further ideas not shown, but definitely possible with Sparky for data pipelines:

- Run different steps of data flow on different Sparky nodes (cluster mode) for scaling and parallelization
- Orchestrate flows from single scenario in various fashion ( wait child jobs, recursive jobs, choreography patterns, etc )
- Distribute compuation tasks and scripts via Sparrow plugins mechanism
 
