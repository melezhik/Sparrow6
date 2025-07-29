# Title

Application less containers 

# description

How to invert k8s deployments using application less containers design 


# tags

k8s, Raku, Sparrow, system-design 

---

Standard containers paradigm, implemented, for example by k8s is that application is a part of container image, so to deploy a new version of application one needs to build a new image and then (re)deployed it, this seems works well for the whole industry.

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

This diagram provides a simplified description of the idea. At certain point of time CICD process would cut new application releases (v_i) and new versions of an application would appear on containers.

Such an approach requires though (in contrast to classic k8s way) an additional abstraction layer (called agents) that pulls new releases and deploy them into containers: 

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
         |   [ .empty.] [ agent ] <--------- GET STATE
         |               | 
         \---------------/ 
                           
```

So the whole deployment schema **gets inverted** and instead of pushing release via kubectl/helm deploy or friends we pull them directly from containers, however from the final result point of view we get the same gitops pattern where all the state is kept as a source code in some Git repository. In other words agents acts as standard configuration management tools, converging containers to desired state, as any confirmation management tools would do. I call it inverted deployment schema.


The benefits of the schema:

- inverted deployment logic give more flexibility

- as we now fully control deployment and configuration process

- no cumbersome init containers, everything is done as separate deployment agent layer:

- from initialization, db migration to sanity checks and cleanup when application crashes

- config reloads are no longer require new kubernetes deployments, just agent pulling new config from remote source and restarting application

- maintenance pages when application needs a considerable time of update are simple as well

- complex and more sophisticated application health checks not covered by standard K8s probes

- kubernetes manifests are kept small and simple, no more YAML/JSON hell of pile of argocd,flux,jsonet,helm/you name it abstractions. Just plain vanilla k8s manifests , everything complex goes to agent layer 

See the next session.


# Agents 

So, apparently empty containers should come with some agents that do all pull/converge magic.

Following are simplified version of Dockerfile required to run "empty box" container. As we are going to use [Raku](https://raku.org) and [Sparrow](https://sparrowhub.io)
configuration management tool, we only need to add those dependencies to base Alpine Linux image:  

## Dockerfile

```Dockerfile
FROM alpine:latest

RUN apk add raku-sparrow6

ENV SP6_REPO=http://sparrowhub.io/repo

ENV SP6_FORMAT_COLOR=1

COPY entry.raku /app/entry.raku

ENTRYPOINT  ["raku", "/app/entry.raku" ]
```

## Entry script (entry.raku)

Following is agent code simplified version, some details are
intentionally omitted, but one can see how  main workflow is handled:

- container initialization
- application restart when a new version is deploy or configuration file changed
- application helth check ( with possible retries or more complex logic )
- container crash or stop cleaning up logic 
- etc 

```raku
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

  # get configuration variables from git state
  my $vars = $state<vars>;

  # deploy configuration file and check if it has changed
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

  my $s = task-run "check app is alive", "http-status";

  # raise an exception if application is not healthy
  # so singnal kubernetes could start a new container

  die "application is not healthy" unless $s<OK>;

  sleep(60); # sleep for 1 minute, could be configurable

}

LEAVE {
  say "container stopped or crashed";
  say "some clean up logic here";
}
```


# Conclusion

Inverted deployment schema, when containers initiate update through agent layers and decoupling application from container could be an interesting alternative to classic container deployment schema, where application always packed into container image and comes together. Such an approach may give a lot flexibility in container life circle management and simplify kubernetes configurations bringing all configuration complexity into agent layers instead of tinkering it inside Dockerfiles/Kubernetes manifests. It also reduces necessity update kubernetes manifests too often ( whether it's gitops style or imperative kubectl apply approach ) and as result simplify operations circle.

Raku and Sparrow may be a good choice when writing configuration management agents layers.  

Please let me know what you think. Comments and feedback are welcome.
