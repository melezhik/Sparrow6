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

Enable Sparrow6 debugging ( basic info )

- SP6_DEBUG_TASK_CHECK

Enable Sparrow6 task checks debugging

- SP6_DEBUG_STREAM

Enable Sparrow6 streams debugging

- SP6_PROFILE

Enable Sparrow6 profiler

- SP6_KEEP_CACHE

Don't remove Sparrow6 cache upon task finish. Useful when  debugging

- SP6_CONFIG

Set path to configuration file.

For example:

    SP6_CONFIG=config.raku

- SP6_CARTON_OFF

Don't use Carton to install CPAN dependencies, useful when one
install CPAN modules though others means


- SP6_TAR_PATH

Path to tar program. For example, for macos users:

    SP6_TAR_PATH=~/homebrew/bin/gtar

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

- SP6_FORMAT_TERSE

Enable terse format ( only scripts output ) in Sparrow reports

- SP6_FORMAT_COLOR

Enable colors in Sparrow reports

- SP6_DUMP_TASK_CODE

Dump code of Sparrow tasks automatically  ( useful for r3 and other test tools )

