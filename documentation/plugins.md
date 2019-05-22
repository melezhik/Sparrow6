# Plugins

Sparrow6 plugins are distributable tasks. 

Users upload plugins to [repositories](https://github.com/melezhik/Sparrow6/blob/master/documentation/repository.md)

To use plugins one need to define `SP6_REPO` environmental variable pointing to certain repository.

For example:

    export SP6_REPO=http://192.168.0.1 # http based repository

    export SP6_REPO=https://192.168.0.1 # https based repository

    export SP6_REPO=ftp://192.168.0.1 # ftp based repository

    export SP6_REPO=file:///var/repo # local repository

# Upload plugin to repository

Once task is [created](https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md) 

one need to create plugin meta file and then upload plugin to repository using Sparrow6 cli

## Plugin meta file

`sparrow.json` is a special file containing all the information required for plugin to be uploaded 
to repository.

`sparrow.json` to be placed in the Sparrow6 task root directory, for example:

    {
        "name": "hello-world",
        "version": "0.1.0",
        "description" : "my very first Sparrow6 plugin",
        "url" : "https://github.com/melezhik/hello-world",
    }

## Plugin meta file structure

* `name` - plugin name.

Only symbols \`a-zA-Z1-9_-.' are allowable in plugin name. This parameter is obligatory, no default value.

* `version` - plugin version

This parameter is obligatory and should be defined in format of [Perl5 version strings](https://metacpan.org/pod/distribution/version/lib/version.pm)

* `description` - a short description of a plugin.

This parameter is optional, but recommended.

* `url` - plugin web site http URL

This parameter is optional and could be useful when one need to refer to plugin documentation site.

* `python_version` - sets Python language version.

In case plugin has pip modules dependencies, respected pip installer version will be chosen.

Available values is 2 or 3.

## Upload plugin

Go to directory with plugin source code and run Sparrow6 cli:

    s6 --upload

That's it! Plugin is ready to use:

    s6 --index-update
    s6 --install hello-world
    s6 --plg-run hello-world

Note that plugin upload operation is only available for local repositories. One can't upload
plugins to remotely.

## Troubleshooting plugin upload

Adding `--debug` flag will print more low level information to console when uploading plugin

# See also

[Repositories](https://github.com/melezhik/Sparrow6/blob/master/documentation/repository.md)

# Author

Alexey Melezhik

# Thanks to

God as the One Who inspires me in my life!

