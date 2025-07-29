---
title: Application less containers 
published: false
description: How to invert k8s deployments using application less containers design 
tags: k8s, Raku, Sparrow, systemdesign 
# cover_image: https://direct_url_to_image.jpg
# Use a ratio of 100:42 for best results.
# published_at: 2025-07-29 13:46 +0000
---

Standard containers paradigm, implemented, for example by k8s is that application is a part of container image, so to deploy a new version of application one needs to build a new image and then (re)deployed it, an it seems it works well for the whole industry.

However things could be a bit different and hopefully more interesting if we subtract  application layer from docker image, so container itself initially becomes just an empty box with some environment that gets instrumented by application binary later at some point of time.

This should work smoothly at least for compiled languages like golang or c where in the most cases application is self-contained binary file:


```

         /-- container --\
         |               |
         |   [ .empty.]  | <--------- application binary ----
         |               | 
         \---------------/ (time)
                           ----  t1 (v1) --- t2 (v2) --- t3(v3)---->
```

Here ^^ on diagram a simplified flow describing  the idea. At certain point of time CICD process would cut new application releases (vi) and new versions of an application would appear on containers.

Such an approach requires though (in contrast to classic k8s way ) an abstraction layer that pulls new releases and deploy them into containers: 


```

         /-- container --\
         |               |
         |   [ .empty.] [ agent ] <--------- GET STATE   
         |               |                       \
         \---------------/                        \
                                                   \
         /-- container --\                          \
         |               |                           \
         |   [ .empty.] [ agent ] <--------- GET STATE  -----+  { GIT REPO }
         |               |                            /
         \---------------/                           /
                                                    /
         /-- container --\                         /
         |               |                        /
         |   [ .empty.] [ agent ] <--------- GET STATE  /  
         |               | 
         \---------------/ 
                           
```

So the whole deployment schema **gets inverted** and instead of pushing release via kubectl/helm deploy or friends we pull them from containers, however from the final result perspective we get the same gitops pattern where all the state is kept as a source code in some Git repository. 

The benefits of the schema:

- inverted deployment logic give more flexibility

- as we now fully control deployment and configuration process

- no cumbersome init containers, everything is done as separate deployment agent layer:

- from initialization, db migration to sanity checks and cleanup when application crashes

- config reloads are no longer require new kubernetes deployments, just agent pulling new config from remote source and restarting application

- maintatnce pages when application needs a considrable time of update are simple aw well
- kubernetes manifests are kept small and simple, no more YAML/JSON hell of pile of argocd,flux,jsonet,helm/you name it abstractions. Just plain vanilla k8s manifests , everything complex goes to agent layer 

See the next session.



# Agents 

So, apparently empty containers should come with some agents that do all pull/converge magic.

Following are simplied version of Dockerfile required to run "emtpy box" container. As we are going to use [Raku](https://raku.org) and [Sparrow](https://sparrowhub.io)
configuration management tool, we only need to add those dependencies to base Alpine Linux image:  

## Dockerfile

```
FROM alpine:latest

RUN apk add raku-sparrow6

ENV SP6_REPO=http://sparrowhub.io/repo

ENV SP6_FORMAT_COLOR=1

COPY entry.raku /app/entry.raku

ENTRYPOINT  ["raku", "/app/entry.raku" ]
```

## Entry script (entry.raku)


Following agent code is simplified version of real code, some details are
intentionally omited 


```
use Sparrow6::DSL
use JSON::Fast;


BEGIN {
  say "container just started";
  say "some init logic here";
}

directory 'state';

while True {

  # checkout git repository with state
  git-scm 'https://git.local/application/app.git', %( :to<state> );

  # load state from checked git repo 
  my $state = from-json("state/state.json".IO.slurp);

  # load current state or initialize with empty HashMap
  my $current-state = "state.json".IO ~~ :e ?? from-json("state.json".IO.slurp) !! %();

  # get configuration variables 
  my $vars = $state<vars>;

  # deploy configuration file and check if it changed
  my $res = task-run "deploy app config", "template6", %(
   :$vars, 
   :target<app.config>,
   :template_dir<templates>,
   :template<app>,
  );

  # restart application if configuration
  # file has changed

  if $res<status> != 0 {
     task-run "service restart", "service-restart", %(
        :pid<app.pid>
     );
  }

  # deploy new version of application
  # if version has changed

  if $state<version> ne $current-state<version> {

     task-run "app stop", "app-stop", %(
        :pid<app.pid>
     );

    task-run "utils/curl", "curl", %(
      args => [
        %( 
          :output<bin/app>,
        ),
        [
          'silent',
          'location'
       ],
        $state<distro-url>
      ]
     );
     task-run "app start", "app-start", %(
        :pid<app.pid>,
        :bin<bin/app>
     );
  }
  sleep(60); # sleep for 1 minute, could be configurable

}

LEAVE {
  say "container stopped or crashed";
  say "some clean up logic here";
}
```


