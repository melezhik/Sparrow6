# Description

CLI utils development using Bash and Sparrow

# Install Sparrow

```bash
sudo apk add raku-sparrow6
s6 --version
```

# Create the very first script

**nano `task.bash`**
```bash
echo "hello world"
```

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

**nano config.yaml**
```yaml
who: Bash
```

## Pass flags

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
Given the code gets copied into Sparrow repository machine, just:

```bash
ssh sparrow-repository-host
git checkout git@github.com:melezhik/sparrow-plugins.git
cd sparrow-plugins/hello
s6 --upload
s6 --index-update
```

Then to use the plugin, on any machine with sparrow installed:

```bash
s6 --index-update
s6 --search hello
```

```bash
s6 --plg-run hello@who=CLI,ok
```
