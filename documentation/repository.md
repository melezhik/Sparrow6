# Sparrow6 Repositories

Sparrow6 repositories store distributable Sparrow6 tasks packaged as plugins.

There are two types of repositories:

- Public - [SparrowHub](https://sparrowhub.org)

SparrowHub is public repository of community Sparrow6 plugins.

- Local

Local files system based repositories, you can host and maintain them through simple Web service (Ninx/Apache):

Init local repository

    repo_root=/var/data/local-repo

    s6 --repo-init $repo_root

Checkout plugins source code from git repository

    git clone https://github.com/melezhik/sparrow-plugins

Upload plugins to local repository

    export SP6_REPO=file://$repo_root

    cd sparrow-plugins

    find -maxdepth 2 -mindepth 2 -name sparrow.json -execdir s6 --upload --debug \;

Serve local repository through httpd/nginx


# See also

[Plugins](https://github.com/melezhik/Sparrow6/blob/master/documentation/plugins.md)

# Author

Alexey Melezhik

# Thanks to

God as the One Who inspires me in my life!

