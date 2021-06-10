# Sparrow6 TAP integration

*** WARNING! This feature is experimental, things could change ***

Sparrow tasks could be easily integrated into Raku [testing](https://docs.raku.org/language/testing) scenarios:

```raku
use Test;
use Sparrow6::DSL;

BEGIN %*ENV<SP6_IGNORE_CHECK_FAIL> = 1;

plan 2;

my ($state, $status) = task-run "tasks/01";

ok($status, "tasks/01");

pass "test2";

done-testing();

```

Run:

```
prove6 -v t/nn.t
```

Output:

```
1..2
[tasks/01] :: OK
# Failed test 'tasks/01'
# at t/nn.t line 12
# You failed 1 test of 2
[task check] stdout match <OK1> False
not ok 1 - tasks/01
ok 2 - test2
t/nn.t .. Dubious, test returned 1
Failed 1/2 subtests

Test Summary Report
-------------------
t/nn.t (Wstat: 256 Tests: 2 Failed: 1)
  Failed tests:  1
Non-zero exit status: 1
Files=1, Tests=2,  0 wallclock secs
Result: FAILED
```

Explanation. 

* `SP6_IGNORE_CHECK_FAIL` environment variables makes Sparrow 
ignore [task checks](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskchecks.md) failures,
so no `exit` gets called on task check failures.

* Instead `task-run` function returns a `state` and `status`. 

* If any of task checks fail, the status will be `False`.

* Now one can just turn a check failure into Raku test `ok()` equivalent:

```raku
my ($state, $status) = task-run "tasks/01";
ok($status, "tasks/01");
```

