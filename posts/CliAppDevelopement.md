# Description

Quick start tutorial on Sparrow automation framework. How to quicky develop CLI utils using Bash and Sparrow.

# Install Sparrow

On Alpine Linux Sparrow gets installed as apk package, on other Linuxes use `zef install Sparrow6` method, using [zef](https://github.com/ugexe/zef) package manager.

```bash
sudo apk add raku-sparrow6
s6 --version
```

# Create the very first script

In Sparrow scripts are called tasks. To write task on Bash, just create task.bash file with some Bash code in it:

**nano `task.bash`**
```bash
echo "hello world"
```

You don't run scripts directly, you use s6 - Sparrow cli to run tasks:

# Run script

```bash
s6 --task-run .
```

Output
```
0:44:01 :: [sparrowtask] - run sparrow task .
10:44:01 :: [sparrowtask] - run [.], thing: .
[task run: task.bash - .]
[task stdout]
10:44:01 :: hello world
```

## Pass parameters

To pass some parameters to task just use `config()` function with task.bash: 

**nano `task.bash`**
```bash
who=$(config who)
echo "hello $who"
```

```bash
s6 --task-run .@who=Sparrow
```

Output
```
10:44:53 :: [sparrowtask] - run sparrow task .@who=Sparrow
10:44:53 :: [sparrowtask] - run [.], thing: .@who=Sparrow
[task run: task.bash - .]
[task stdout]
10:44:54 :: hello Sparrow
```

## Default parameters

Parameters could have default values in case no values provided via cli, just creat config.yaml with some default parameters in it:

**nano config.yaml**
```yaml
who: Bash
```

## Pass flags

Parameters could be integers, strings or booleans - aka flags, to pass boolean True parameter, just don't provide any value via cli call (see bellow):

**nano `task.bash`**
```bash
who=$(config who)
ok=$(config ok)

echo "hello $who"

if [[ $ok = "True" ]]; then
   echo "I am ok"
else
  echo "What's the matter?"
fi
```

```bash
s6 --task-run .@who=Sparrow,ok
```

Output
```
10:45:50 :: [sparrowtask] - run sparrow task .@who=Sparrow,ok
10:45:50 :: [sparrowtask] - run [.], thing: .@who=Sparrow,ok
[task run: task.bash - .]
[task stdout]
10:45:51 :: hello Sparrow
10:45:51 :: I am ok
```

## Task checks

[Task checks](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskchecks.md) is powerfull self testing mechanism allowing validate tasks outout, just create task.check file with some check rules inside, rules could be plain strings
or Raku regular expressions or other powerfull expressions not covered in this simple example 
 
**nano task.check**
```
# the script should print "hello"
hello
```

```bash
s6 --task-run .@who=Sparrow,ok
```

Output
```
10:47:16 :: [sparrowtask] - run sparrow task .@who=Sparrow,ok
10:47:16 :: [sparrowtask] - run [.], thing: .@who=Sparrow,ok
[task run: task.bash - .]
[task stdout]
10:47:18 :: hello Sparrow
10:47:18 :: I am ok
[task check]
stdout match <hello> True
```

## Make it a plugin

To install task on other server, one need to wrap task into sparrow plugin. Sparrow [plugins](https://github.com/melezhik/Sparrow6/blob/master/documentation/plugins.md) mechanism allow distrubute tasks over http/rsync/ftp API
through so called [repositories](https://github.com/melezhik/Sparrow6/blob/master/documentation/repository.md). Follwing an example of converting task.bash into Sparrow plugin


1. Create sparrow.json file with plugin meta data

**nano sparrow.json**

```json
{
  "name" : "hello",
  "description" : "Hello Plugin",
  "version" : "0.0.1",
  "url" : "https://github.com/melezhik/sparrow-plugins/tree/master/hello",
  "category": "demo, Bash"
}
```

2. Copy task code to some git repostiry and check it out on machine where Sparrow repositiry located
 
```bash
ssh sparrow-repository-host
git checkout git@github.com:melezhik/sparrow-plugins.git
```


Once task code is located in machine with Sparrow repository, upload it
to a repository:

```
cd sparrow-plugins/hello
s6 --upload
s6 --index-update
```

Then to use the plugin, on any machine with Sparrow installed:

```bash
s6 --index-update
s6 --search hello
```

Output

```
10:53:48 :: [repository] - search plugins
hello ... Nil ... 0.0.1
```

The run the plugin

```bash
s6 --plg-run hello@who=CLI,ok
```

Output

```
10:54:32 :: [task] - run plg hello@who=CLI,ok
10:54:32 :: [task] - run [hello], thing: hello@who=CLI,ok
10:54:32 :: [repository] - installing hello, version 0.000001
[task run: task.bash - hello]
[task stdout]
10:54:33 :: hello CLI
10:54:33 :: I am ok
[task check]
stdout match <hello> True
```
