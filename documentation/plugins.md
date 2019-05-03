# Plugins

Sparrow6 plugins are distributable tasks. 

Users can choose between public repository ( SparrowHub ) 

and local file storage repository to distribute their tasks.

Set `SP6_REPO` environmental variable to define repository:

    export SP6_REPO=https://sparrowhub.org # SparrowHub repository

    export SP6_REPO=file:///var/data/local-repository # local repository


# Upload plugin to repository

Once task is [created](https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md) you should do 4 simple steps:

* Get registered on SparrowHub and create a token ( you don't need this step if you upload to local repository )

* Setup sparrowhub.json file ( you don't need this step if you upload to local repository )

* Create a plugin meta file - sparrow.json

* Upload a plugin with the help of `s6 --upload` command

## Get registered on SparrowHub

* Go to [https://sparrowhub.org/sign_up](https://sparrowhub.org/sign_up) and create an account

## Generate a token

Login into SparrowHub, go to Profile page and hit "Regenerate Token" on  [https://sparrowhub.org/token](https://sparrowhub.org/token)  page.

## Setup sparrowhub.json

Once your get you token, setup a sparrowhub credentials on the machine where you are going upload plugin from:

    ~/sparrowhub.json

      {
          "user"  : "melezhik",
          "token" : "ADB4F4DC-9F3B-11E5-B394-D4E152C9AB83"
      }

***NOTE!*** Another way to provide SparrowHub credentials is to set `$SP6_REPO_USER` and `$SP6_REPO_TOKEN` environment variables:

    export SP6_REPO_USER=melezhik

    export SP6_REPO_TOKEN=ADB4F4DC-9F3B-11E5-B394-D4E152C9AB83


## Create plugin meta file

Sparrow.json file holds plugin meta information required for plugin gets uploaded to SparrowHub.

Create `sparrow.json` file and place it in a plugin root directory:

    {
        "name": "my-plugin",
        "version": "0.1.0",
        "description" : "the plugin to do some tasks",
        "url" : "https://github.com/melezhik/my-plugin",
    }

## Meta file structure

* `name` - plugin name.

Only symbols \`a-zA-Z1-9_-.' are allowable in plugin name. This parameter is obligatory, no default value.

* `version` - Perl version string.

This parameter is obligatory. A detailed information concerning version syntax could be find here -
[https://metacpan.org/pod/distribution/version/lib/version.pm](https://metacpan.org/pod/distribution/version/lib/version.pm)


* `url` - a plugin web site http URL

This parameter is optional and could be useful when you want to refer users to plugin documentation site.

* `description` - a short description of a plugin.

This one is optional, but very appreciated.

* `python_version` - sets Python language version.

If you install pip modules targeted for Python3 you may set python_version in sparrow.json file:

    python_version : 3

That will ensure to use `pip3` ( not `pip` ) to install dependencies in `requirements.txt` file

* `sparrow6_version` - sets minimal version of Sparrow6 required by plugin.

This is mostly useful for Sparrow6 plugin developers. Some plugins may rely on the latest versions of Sparrow6 and
couldn't run correctly on the older versions, to avoid any confusion plugins developers may declare
a minimum version so that if the target machine does have it an exception will be raised.


## Upload plugin

Go to directory where your plugin source code and:

    s6 --upload

That's it!

If you want to troubleshoot upload plugin errors use `--debug` flag.

# See also 

[Repositories](https://github.com/melezhik/Sparrow6/blob/master/documentation/repository.md)

# Author

Alexey Melezhik

# Thanks to

God as the One Who inspires me in my life!

