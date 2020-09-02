# Roadmap

The Roadmap of Sparrow6 project development.

# Done

+ Perl/Bash tasks
+ test.pl6 - embedded test support ( aka m10 - METEN minimalistic embedded test engine )
+ multiroot story support ( ability to run multi root stories  )
+ ignore_story_err implementation
+ set_stdout implementation
+ ignore_error() instead of ignore_story_err()
+ implement cwd attribute
+ implement purge-cache
+ Add self!set-sparrow-root(); to Sparrow6::SparrowHub::API constructor
+ s6 - install/search/list plugin
+ freeze SparrowHub index for Sparrow/Perl5, disable upload action
+ read config support (set-conf/conf/SP6_CONF)
+ sudo support
+ Implement os() function
+ Rewrite resources/sparrow6common.pm to Perl6
+ Port Sparrowdo::DSL to Sparrow6::DSL
+ Sparrowdo - convert outthentic tests to regular tests
+ Sparrowdo - support for config
+ Sparrow6::Task::Runner::Api story => task renaming
+ Sparrowdo [copy local files](https://github.com/melezhik/sparrowdo/blob/master/core-dsl.md#copy-local-files)
+ Regexp interpolation
+ Sequences, Ranges, Withins
+ Streams for Sequences, Ranges and Withins
+ Handle comments inside code/generators correctly
+ Port Otthentic::DSL tests to Sparrow6
+ Don't allow  nested contexts
+ Task states ( ability to exchange data between tasks - implimented for Perl )
+ Ruby support
+ Python support
+ Document Sparrow6::Task::Check
+ S6 - `--repo-init` command
+ Document task states
+ Ruby plugins, bundle install test
+ Rename sparrow.index to index
+ module_run added
+ Powershell support
+ Renaming: suite.yaml => config.yaml
+ Renaming: story* => task*
+ Renaming: story  => task
+ Renaming: story.check  => task.check
+ Rewrite Sparrow client to s6 ( Sparrow::S6 )
+ Switch Tomtit to Updated Sparrowdo version ( github master branch )
+ Switch Sparrowdo to Updated Sparrowdo version ( github master branch )
+ SparrowHub reference removed from docs
+ modules/ => tasks/ renaming
+ ignore_task_err => ignore_task_error renaming
+ story_run => task_run renaming
+ story_var => task_var renaming
+ Consider lightweight SparrowHub alternative ( Azure free host, domain ) - http://repo.southcentralus.cloudapp.azure.com
+ Create information on SparrowHub retirement - reddit
+ s6 cli module-run added
+ Documenting repo.southcentralus.cloudapp.azure.com
+ Perl6 support ( after renaming )
+ Args stringification

# Urgent

- Reconsider Sparrowdo bootstrap ( need to remove some packages from there - git, perl ? )

# New syntax / renaming

- target_os() => os() # implemented but should be documented
- meta.txt => task.txt (???)
- sparrow.json => sparrow6.json (?)

# New features

These features are almost done, just list them here

- Task states ( ability to exchange data between tasks )
- config.pl6 support (???)
- m10
- `streams` # streams presented as a Hash ( need to document )
- `streams_arrays` # streams presented as an Array ( need to document )
- `dump_streams` ( implemeted for Perl, need to document )
- `note:` expressions ( done, need to document )
- m10 ( need to add more helpers )
- Low priority - document Sparrow6::Task::Runner Class
- Low priority - document m10 feature ( METEN - Minimalistic Embedded Testing Engine )
- Low priority - `s6 --install` install plugin without plugin name ( read data from sparrow.json in CWD )

# Documentation

- hook set_stdout gets merged with task stdout in ( implimented, need to document )
- task check is not triggered if there is no task  ( implimented, need to document ) - breaking changes

# Questionable

- Sparrowdo - Sparrow6::DSL::Assert - workaround for `input_param` method
- Sparrowdo - support for target_host
- Sparrowdo - cwd cli support ( do we need it? )
- Sparrowdo - vagrant support ( do we need it ? )
- Sparrowdo - git ( Sparrlets support, do we need it ? )
- Sparrowdo - `var=name=value` command line support
- Sparrowdo - `module_run`, `task_run` cli options support
- Deprecate set_stdout (???), hook stdout should contribute to task stdout (???)
- Don't allow generators/codes if check failures (???)
- Handle code failures in task checks (???)
- Impliment cwd parameter for Sparrow6 tasks
- Use api/v2 instead of api/v1
- meta.txt support
- Supporting outthentic messages
- Color/nocolor output
- Dry run support (??? is it possible with Sparrow6? I doubt)
- suite.json config support

# Medium priority

- Port existed Sparrowdo:: Modules to Sparrow6
- Adjust existing Sparrow plugins ( documentation fixes, compatibility with Sparrow6 core )
- Plugins - fix Perl5 generators as Array refs
- Write tests for Ruby common libraries - $task-dir/common.rb $root-dir/common.rb
- Write tests for Powershell streams support

# Low priority

- s6 cli - save / restore tasks
- Task descriptions (task.txt)
- dump_streams() implimentation for Ruby, Python, Powershell
- Windows support ( run stories, run hooks )
- Catch stderr for hooks/stories (?)
- Don't strip comments from one-line code and generator expressions


# Other tools support

- Switch Sparky to Updated Sparrowdo version ( done partly, need to check )
- Port Sparrowform to Sparrow6
- Make Old Sparrowhub plugins compatible with Sparrow6


# Breaking changes

- SparrowHub is removed
- truncating to the `match_l` is removed, we reports check results as is, even for really long matched strings (examples/match-length.pl6)
- `:blank` is deprecated, you should use regexp: `^^ \s* $$`  instead
- `suite.ini`, `suite.json` are not supported
- `story.pm` files are not supported
-  task recursive execution is not supported
- `outthentic_die`, `outthentic_exit` functions are not supported
- old reports formats ("production, default, concise") are not supported
- private plugins supports dropped in favor of private repositories

