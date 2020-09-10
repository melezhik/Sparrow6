# Sparrow Repositories

Sparrow repositories store distributable Sparrow tasks packaged as plugins.

## Repositories types

There are two types of repositories:

- Remote

Http / Ftp / Rsync based repositories

- Local

Local files system based repositories

## Public http repository

[http://repo.southcentralus.cloudapp.azure.com](http://repo.southcentralus.cloudapp.azure.com) is a public repository with many Sparrow6 plugins.

## Create repository

One need to create repository root directory:

    repo_root=/var/repo
    mkdir $repo_root

And then initialize the directory using Sparrow6 cli:

    s6 --repo-init $repo_root

Then just checkout plugins source code from scm and upload to the repository:

    git clone https://github.com/melezhik/sparrow-plugins

    export SP6_REPO=file://$repo_root

    cd sparrow-plugins

    find -maxdepth 2 -mindepth 2 -name sparrow.json -execdir s6 --upload \;


The process of creation of remote repositories follows the same logic, with only difference 
that one need to maintain serving repository index and files through web/ftp/rsync server.

For example for http based repository one can choose nginx web server with root directory equal to repository root:

    listen 192.168.0.1:80;

    location / {
        root /var/repo/
    }

To use remote repository simple set `SP6_REPO` variable:

    export SP6_REPO=http://192.168.0.1

# See also

[Plugins](https://github.com/melezhik/Sparrow6/blob/master/documentation/plugins.md)

# Author

Alexey Melezhik

# Thanks to

God as the One Who inspires me in my life!

