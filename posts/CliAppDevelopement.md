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

## Pass parameters

**nano `task.bash`**
```bash
who=$(config who)
echo "hello $who"
```

```bash
s6 --task-run @who=Sparrow
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


