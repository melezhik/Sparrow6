# Tomtit - simple cli task runner with a lot of plugins

[Tomtit](https://github.com/melezhik/Tomtit) is a cli task runner when you need to run repetitive tasks / tools around your project. It's similar to make, but with more generic approach, not exactly tied to build tasks only

Here is a quick start


# Installation

```bash
zef install Tomtit --/test
```

# Create hello world task

Once Tomtit is installed, there is `tom` cli to create, run tasks:

```bash
tom --edit build 
```

```raku
#!raku
task-run "tasks/make";
```

This step only creates a Raku wrapper for some `tasks/make` task. As we going to write it on Bash all we need to do is
to create some Bash script that is going to be invoked from Raku as normal Raku function "task-run". We don't necessarily need to
do things that way, but sometime it's just more convenient to separate Bash and Raku logic to keep things clean and simple to maintain, Tomtit allows to do that effectively:

```bash
mkdir -p tasks/make
nano tasks/make/task.bash
```

```bash
!bash
make
make test
sudo make install
```

Now we can drop some Makefile to cwd, and run make task as following:


```bash
tom make
```

# Tasks parameters

Tomtit provides a nice way to pass parameters to tasks, by using environments. Under the hood environments are plain Raku HashMap objects that get loaded into task context allowing tasks configurations depending on `--env $env_name` cli parameter:


```bash
tom --env-edit prod
```

```raku
#!raku
%(
  :prod
);
```

And then with slight modification of Raku scenario and Bash task code:

```raku
#!raku
my $prod = config()<prod>;
task-run "tasks/make", %(
  :$prod
);
```

```bash
#!bash

prod=$(config prod)

if test "$prod" = True; then
  make mode=prod
else
  make
fi
make test
sudo make install 
```

We can run task with production mode enabled:

```bash
tom --env=prod make
```

To set default env just use `--set-env` flag:

```bash
tom --env-set prod
```

# Plugins

The power of Tomtit is a lot of included [plugins](https://sparrowhub.io/search?q=all), to use plugins, just export plugin repository variable:

```bash
export SP6_REPO=http://sparrowhub.io/repo
```

And then add plugin as a function into Tomtit scenario. For example, instead of running local make task we may want to
to run build remotely on Gitlab CI using plugin:

```raku
#!raku
my $prod = config()<prod>,
task-run "make", "gitlab-run-pipeline", %(
  :1001_project,
  :gitlab_api<https://git.company.com/api/v4/>,
  variables => %(
    :$prod,
  )
);
```

# Conclusion

Tomtit has more cool features not covered here, this is just a short quick start introduction with
intention to give you some rough ideas what Tomtit is.

---

Please post your comments and feedback
