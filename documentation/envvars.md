# Environmental variables

Sparrow6 environmental variables list.

- SP6_REPO 

Sets Sparrow6 Repository url.

For example:

    SP6_REPO=file:///var/sparrow-local-repo

    SP6_REPO=https://sparrowhub.org

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


