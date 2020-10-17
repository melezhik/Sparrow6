# Environmental variables

Sparrow6 environmental variables list.

- SP6_REPO

Sets Sparrow6 Repository url.

For example:

    SP6_REPO=file:///var/sparrow-local-repo

    SP6_REPO=http://192.168.0.1

- SP6_TASK_ROOT

Set root directory for local tasks

For example:

    SP6_TASK_ROOT=~/tasks

Once is set Sparrow6 will look tasks locations in `SP6_TASK_ROOT`, not just in `CWD`:

    task-run "birds" # Will look in ./birds,  then in ~/tasks/birds

- SP6_DEBUG

Enable Sparrow6 debugging

- SP6_KEEP_CACHE

Don't remove Sparrow6 cache upon task finish. Useful when  debugging.

- SP6_CONFIG

Set path to configuration file.

For example:

    SP6_CONFIG=config.pl6

- SP6_CARTON_OFF

Don't use Carton to install CPAN dependencies, useful when one
install CPAN modules though others means


- SP6_TAGS

Tags for hosts. Mostly used in Sparrowdo scenarios, to separate one hosts from another
or supply scenarios with variables.

For example:

    SP6_TAG=database,prod

So in sparrow scenario:

    if tags()<database> && tags()<prod> {
      package-install "postgresql";
      task-run "harden postgresql config", "postgresql-strict-configuration";
    }

Tags might also contain values, representing 'key/value' pairs:

    SP6_TAG=nginx_port=443,mode=production

Sparrow scenario:

    say tags()<nginx_port>;
    say tags()<mode>;


- SP6_LOG_NO_TIMESTAMPS

Don't add timestamps to Sparrow reports
