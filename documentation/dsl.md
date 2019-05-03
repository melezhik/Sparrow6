# SYNOPSIS

Sparrow6 DSL functions spec.

* [User accounts](#user-accounts)
* [User groups](#user-groups)
* [Packages](#packages)
  * [System packages](#system-packages)
  * [CPAN packages](#cpan-packages)
  * [Zef modules](#zef-modules)
* [Services](#services)
  * [Systemd](#systemd)
* [Directories](#directories)
* [Files](#files)
* [Copy local files](#copy-local-files)
* [Templates](#templates)
* [Bash commands](#bash-commands)
* [Source control](#source-control)
  * [Git](#git)
* [Ssh commands](#ssh)
* [Scp command](#scp)
* [Asserts](#asserts)

## User accounts

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| user-create | create user | `user-create($name)`| [user](https://sparrowhub.org/info/user) | 
| user-delete | delete user | `user-delete($name)`| [user](https://sparrowhub.org/info/user) |
| user        | create/delete user | `user($name,[%args])`| [user](https://sparrowhub.org/info/user) |

Examples:


    user-create 'alexey'; # create user `alexey'
    user-delete 'alexey'; # delete user `alexey'
    user 'alexey'; # short form of user create
    user 'alexey', %(action => 'create'); # hash parameters form of user create
    user 'alexey', %(action => 'delete'); # hash parameters form of user delete

## User groups

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| group-create | create group | `group-create($name)`| [group](https://sparrowhub.org/info/group) | 
| group-delete | delete group | `group-delete($name)`| [group](https://sparrowhub.org/info/group) |
| group        | create/delete group | `group($name,[%args])`| [group](https://sparrowhub.org/info/group) |

Examples:


    group-create 'sparrows'; # create group `sparrows'
    group-delete 'sparrows'; # delete group `sparrows'
    group 'sparrows'; # short form of group create
    group 'sparrows', %(action => 'create'); # hash parameters form of group create
    group 'sparrows', %(action => 'delete'); # hash parameters form of group delete

## Packages

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| package-install | install software package | `package-install(@list\|$list)` | [package-generic](https://sparrowhub.org/info/package-generic) |
| cpan-package-install | install CPAN package | `cpan-package-install(@list\|$list,%opts)` | [cpan-package](https://sparrowhub.org/info/cpan-package) | 
| cpan-package         | alias for cpan-install function | * | *  |

Examples:

### System packages

    # pass list as Array
    package-install ('nano', 'tree', 'mc');

    # pass list as String, 
    # packages are space separated items 
    package-install 'nano tree mc';
    package-install 'nano';

### CPAN packages

    # install 3 cpan modules, system wide paths
    cpan-package-install ('CGI', 'Config::Tiny', 'HTTP::Tiny');
    
    # short form of above
    cpan-package ('CGI', 'Config::Tiny', 'HTTP::Tiny');
    
    # install 3 cpan modules, users install
    cpan-package-install 'CGI Config::Tiny HTTP::Tiny', %(
        user =>'foo',
        install-base => '/home/foo/',
    );
    
    # the same as above but passing cpan modules list as Array
    cpan-package-install ('CGI', 'Config::Tiny', 'HTTP::Path'), %(
        user =>'foo',
        install-base => '/home/foo/',
    );

### Zef modules

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| zef | install zef module | `zef($module,[%opts])` | * | 

Examples:

    # install DBIish module
    zef 'DBIish';

    # Force install
    zef 'DBIish', %( force => True );

    # User's install
    zef 'DBIish', %( user => 'me' );

    # Skip tests
    zef 'DBIish', %( notest => True );

    # Only dependencies, inside CWD
    zef '.', %( depsonly => True );

    # Sets custom description
    zef 'DBIish', %( description => 'Database interface module' );

    # Show debug info when install
    zef 'DBIish', %( debug => True );
  

## Services

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| service-start | start service | `service-start($name)`| [service](https://sparrowhub.org/info/service) | 
| service-restart | restart service | `service-restart($name)`| [service](https://sparrowhub.org/info/service) | 
| service-stop | stop service | `service-stop($name)`| [service](https://sparrowhub.org/info/service) | 
| service-enable | enable service | `service-enable($name)`| [service](https://sparrowhub.org/info/service) | 
| service-disable | disable service | `service-disable($name)`| [service](https://sparrowhub.org/info/service) | 
| service       | start/stop/restart/enable/disable service | `service($name, %args)`| [service](https://sparrowhub.org/info/service) |

Examples:

    service-enable 'nginx';
    
    service-start 'nginx';
    
    service-stop 'nginx';
    
    service-restart 'nginx';
    
    service 'nginx', %( action => 'stop' );
    
    service 'nginx', %( action => 'disable' );
    
    service-disable 'nginx';
    
### Systemd

Sparrowdo provides limited and poorly tested API for Systemd scripts. Here is example how you can  use it:

    user "foo";

    # install systemd script for some service and reload systemd daemon
    systemd-service "long-dream", %(
      user => "foo",
      workdir => "/home/foo",
      command => "/bin/bash -c 'sleep 10000'"
    );

    # start service
    service-start "long-dream";

Basically it's `systemd-service` function with parameters:

* `name` - service name
* `user` - sets the user to own service process
* `command` - sets the service command
* `workdir` - sets working directory

All the parameters are required.


## Directories

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| directory-create | create directory | `directory-create($path,%args)`| [directory](https://sparrowhub.org/info/directory) | 
| directory-delete | delete directory | `directory-delete($path)`| [directory](https://sparrowhub.org/info/directory) |
| directory        | create/delete directory | `directory($path,[%args])`| [directory](https://sparrowhub.org/info/directory) |

Examples:

    directory '/tmp/baz';

    directory-create '/tmp/baz';

    directory-create '/tmp/foo/bar', %(
      recursive => 1 ,
      owner => 'foo',
      mode => '755'
    );
    
    directory '/tmp/foo/bar/bar/123', %(
      action => 'create',
      recursive => 1 ,
      owner => 'foo',
      mode => '755'
    );
    
    
    directory-delete '/tmp/foo/bar';

## Files

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| file-create | create file | `file-create($path,%args)`| [file](https://sparrowhub.org/info/file) | 
| file-delete | delete file | `file-delete($path)`| [file](https://sparrowhub.org/info/file) |
| file        | create/delete file | `file($path,[%args])`| [file](https://sparrowhub.org/info/file) |

Examples:

    # just create (touch) an empty file
    file-create '/var/data/animals.txt';

    # shortcut for file-create
    file '/var/data/animals.txt';

    # copy file from source
    file '/var/data/animals.txt', %( source => '/var/data/backup/animals.txt' );

    # sets file attributes
    file '/var/data/animals.txt', %(
      owner => 'zookeeper',
      group => 'animals' ,
      mode => '644',
      content => 'I am read fox!'
    );

    # sets file content explicitly
    file '/var/data/animals.txt', %(
      action  => 'create',
      owner   => 'zookeeper',
      group   => 'animals' ,
      mode    => '644',
      content => 'I am read fox!'
    );
    
    file-delete '/var/data/animals.txt';

    # the same as above
    file '/var/data/animals.txt', %( action => 'delete' );

## Copy local files 

Sparrowdo provides limited API to copy local files at your project to remote server:

    copy-local-file 'data/hello.txt','/tmp/hello.txt';

This code will copy file located at $*PWD/data/hello.txt to remote server under location '/tmp/hello.txt'.
Please aware that local file coping gets happened at the very beginning of sparrowdo scenario execution, so this
code ***won't work*** unless you have a remote directory /opt/data exists at the target server:

    copy-local-file 'data/hello.txt','/opt/data/hello.txt';

And even this won't help you due to local file coping gets happened first:

    directory '/opt/data/';
    copy-local-file 'data/hello.txt','/opt/data/hello.txt';

But you can use `$sparrow-root/sparrow-cache/files` directory ( which existence is ensured ) to keep your data safely:

    copy-local-file 'data/hello.txt','/opt/sparrow/sparrow-cache/files';

And then:

    directory '/opt/data/';

    file '/opt/data/hello.txt', %( source => /opt/sparrow/sparrow-cache/files/hello.txt );

## Templates

Templates are files gets populated from templates sources in [Template-Toolkit](http://template-toolkit.org/) format.

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| template-create | create template | `template-create($path,%args)`| [templater](https://sparrowhub.org/info/templater) | 
| template        | alias for template-create | * | * |

Examples:

    # build /var/data/animals.txt from template

    $ cat examples/templates/animals.tmpl

    Hello, my name is [% name %]!
    I speak [% language %]

    template-create '/var/data/animals.txt', %(
      source => ( slurp 'examples/templates/animals.tmpl' ),
      owner => 'zookeeper',
      group => 'animals' ,
      mode => '644',
      variables => %(
        name => 'red fox',
        language => 'English'
      ),
    );
    

    # trigger action when /var/data/animals.txt changed

    template-create '/var/data/animals.txt', %(
      source => ( slurp 'examples/templates/animals.tmpl' ),
      variables => %(
        name => 'green fox',
        language => 'Spanish'
      ),
      on_change => "echo /var/data/animals.txt changed"
    );
    
## Bash commands

This function executes bash code.

| function | description | usage | Sparrow6 plugin |
| -------- | ----------- | ----- | --------------- |
| bash | execute bash, default user | `bash($command)`| [bash](https://sparrowhub.org/info/bash) | 
| bash | execute bash, for user | `bash($command,$user)`| [bash](https://sparrowhub.org/info/bash) |
| bash | execute bash, generic form | `bash($command,%args)`| [bash](https://sparrowhub.org/info/bash) |

Examples:

    # execute bash for default user 
    bash(q:to/HERE/);
      set -e;
      touch /tmp/sparrow123.txt
      echo one
      echo two
      echo three
    HERE
    
    # one-liner
    bash('echo hello world');
    

    # execute command for `foo' user    
    bash('pwd', 'foo');
    

    # pass parameters as Hash, many options here:

    # check STDOUT from executed command
    bash 'pwd', %(
      user => 'foo',
      expect_stdout => '/home/foo'
    );

    # enable debug mode ( set -x ):
    bash 'very-long-command', %( debug => 1 );
    
    # or passing environment variables:
    bash 'echo $FOO; echo $BAR', %(
      envvars => %(
        FOO => 'the-foo',
        BAR => 'the-bar',
      )
    )

    # sets description for bash command 
    # ( will be printed at sparrowdo report instead of dummy "execute bash command" )
    bash "ls -l", %( 
      description => "use this description for bash command" 
    );    


## Source control

### Git

| function | description | usage |
| -------- | ----------- | ----- |
| git-scm | checkout source from git repository  | `ssh($source,[%args])` |

Examples:

    # checkout source from https://github.com/melezhik/sparrow.git
    # to the current working directory
    git-scm 'https://github.com/melezhik/sparrow.git';


    # checkout source from https://github.com/melezhik/sparrow.git
    # into /tmp/foo directory
    directory '/tmp/foo';
    git-scm 'https://github.com/melezhik/sparrow.git', %( to => '/tmp/foo' );

    # Specify ssh key for authentification
    git-scm 'ssh://git@github.com/melezhik/sparrow.git', %( to => '/tmp/foo', ssh-key => '/tmp/my.key' );

    # ssh authentification with unknown server key
    git-scm 'ssh://git@github.com/melezhik/sparrow.git', %( to => '/tmp/foo', ssh-key => '/tmp/my.key', accept-hostkey => True );

    # checkout under user
    git-scm 'https://github.com/melezhik/sparrow.git', %( to => '/tmp/foo', user => 'alexey' );

    # checkout a branch
    git-scm 'https://github.com/melezhik/sparrow.git', %( branch => 'dev/foo-bar' );

    # enable debug
    git-scm 'https://github.com/melezhik/sparrow.git', %( to => '/tmp/foo', debug => True );


## Ssh

This function executes ssh commands.

| function | description | usage |
| -------- | ----------- | ----- |
| ssh | execute ssh commands | `ssh($command,%args)` |
| ssh | alias for `ssh` with command set via %args | `ssh(%args)` |

Examples:

    # ssh to 192.168.0.1 and execute 'uptime'
    # a shortest form, only obligatory parameters are set:
    ssh 'uptime', %( host => '192.168.0.1' )

    # the same but add description for command:
    ssh 'uptime', %( host => '192.168.0.1' , description => "how old are you?" );

    # you also may set a user:
    ssh 'uptime', %(
      host  => '192.168.0.1',
      user  => 'old_dog'
    );

    # and ssh_key
    ssh 'uptime', %(
      host    => '192.168.0.1',
      user    => 'old-dog',
      ssh-key => 'keys/id_rsa'
    );


    # an example for multiline command
    ssh q:to/CMD/, %( host => '192.168.0.1', user => 'old_dog');
      set -e
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get install -y -qq curl
    CMD
  
    # create $create file upon successful execution
    # prevent from running ssh command next time if file $create exist:
    ssh "run-me", %(  host => '192.168.0.1' , create => '/do/not/run/twice' )


## Scp

This function copies files from/to target host from/to remote host

| function | description | usage |
| -------- | ----------- | ----- |
| scp | copy files remotely by scp | scp(%args)

Example:

    # copy files dir1/file1 dir2/file2 dir3/file3 to target server to 192.168.0.1
    scp %( 
      data    => "dir1/file1 dir2/file2 dir3/file3",
      host    => "192.168.0.1", 
    );


    # copy files dir1/file1 dir2/file2 dir3/file3 to target server to 192.168.0.1
    # set ssh private key and user id 
    scp %( 
      data    => "dir1/file1 dir2/file2 dir3/file3",
      host    => "192.168.0.1", 
      user    => 'old-dog',
      ssh-key => 'keys/id_rsa'
    );


    # copy file dir1/file1 from target server to 192.168.0.1, destination dir2
    scp %( 
      data    => "dir2/",
      host    => "192.168.0.1:dir1/file1", 
      user    => "Me",
      pull    => 1, 
    );


    # copy files dir1/file1 dir2/file2 dir3/file3 to target server to 192.168.0.1
    # do not copy if /tmp/do/not/copy/twice exists at target server
    scp %( 
      data    => "dir1/file1 dir2/file2 dir3/file3",
      host    => "192.168.0.1", 
      create  => "/tmp/do/not/copy/twice"
    );



## Asserts

Asserts are functions to audit your server state. Here are some examples 
( list is not full , I will add more eventfully )

### Check if process exists

    # ensure existence by PID taken from /var/run/sshd.pid
    proc-exists 'sshd';
    
    # ensure existence by footprint
    proc-exists-by-footprint 'sshd', 'sshd\s+-D';
    
    # ensure existence by footprint
    proc-exists-by-pid 'sshd', '/var/run/sshd.pid';
    

## Check if http resource accessible

It's just simple check by `curl's GET` with follow redirect enabled.

    http-ok 'http://sparrowhub.org';

Ignore http proxy when making request:

    http-ok 'localhost', %( no-proxy => True );

Use `ssh host` command line parameter as URL:

    http-ok;

The same as above but with `port` and `path`:

    http-ok %( port  => '8080' , path => '/Foo/Bar' );

Checks that web page has content:

    http-ok 'http://sparrowhub.org', %( has-content => 'SparrowHub' );
 

## Helper functions

Sparrow6::DSL provides set of helpers function might be useful when developing
cross platform scenarios

* `os()`

This function returns the remote server OS name.

For example:

    if os() ~~ m/centos/ {
      'package-install' ( 'epel-release', 'nginx' );
    } else {
      'package-install' 'nginx' ;
    }

The list of OS names is provided by `os()` function:

    centos5
    centos6
    centos7
    ubuntu
    debian
    minoca
    archlinux
    alpine
    fedora
    amazon
    funtoo
    windows
    darwin

Though `os()` function return a wide list of different operation systems,
respected Sparrow6 plugins can support different operation system selectively


# See also

[Sparrowdo](https://github.com/melezhik/sparrowdo/tree/Sparrow6) - configuration management tool based on Sparrow6.

