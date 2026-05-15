---
name: sparrow6-taskchecks-raku-regex
description: Expert in Sparrow6 Task Check DSL for text verification and Raku regex syntax. Use when writing task check files (task.check), crafting Raku regular expressions, or working with Sparrow6 project verification scenarios. Covers DSL syntax, regex patterns, generators, assertions, captures, and search context modifiers.
license: MIT
compatibility: Requires Sparrow6 for task check execution; Raku regex knowledge applicable in any Raku environment.
metadata:
  author: kilocode-community
  version: "1.0"
  category: domain-expertise
---

# Sparrow6 Task Check DSL & Raku Regex Expert Skill

This skill provides comprehensive knowledge for working with Sparrow6 Task Check DSL and Raku regular expressions. Use it when you need to write verification rules for structured/unstructured text output or craft Raku regex patterns.

---

## Sparrow6 Task Check DSL

### Core Concepts

**Purpose:** 

Regexp-based DSL to verify structured and unstructured text output. Input text is parsed line by line and analyzed on a per-line basis.

**Key Terminology:**

- TC (Task Check) Language — "The DSL itself, both imperative and declarative"
- Task Check File — DSL code written in a `task.check` file
- DSL Parser — Program that parses DSL code, parses input data, and verifies input line by line against check expressions
- Search Context — The current scope of input text being examined; can be narrowed by context modifiers

**Verification Algorithm:**

1. For every check expression: calculate current search context
2. Set check step status as `unknown`
3. For every line in input text:  if line matches expression, mark status `succeeded`
4. After loop: if status remains `unknown`, mark `failed`
5. If all check steps succeeded → overall success; otherwise failure

⚠️ Critical:** A failed check does **not** terminate the scenario immediately. The parser marks the failure internally and continues. The final result reflects all accumulated failures.

**Supported Languages:** 

Raku, Perl5, Bash, Ruby, Python, PowerShell, PHP. 

Sparrow6 provides API functions: `matched()`, `captures()`, `streams_array()`, etc.

### DSL Syntax

The TC language consists of these building blocks:

| Building Block | Purpose |
------------------------------------------------
| Comments / blank lines / here documents | Documentation and structure |
| **Check expressions** | Patterns to match input data |
| **Plain strings** | Exact case-sensitive text matching |
| **Regular expressions** | Raku regex patterns |
| **Assert expressions** | Boolean assertions for captured data |
| **Search context modifiers** | `sequence`, `range`, `within` expressions |
| **Generator expressions** | Dynamically generate DSL code |
| **Code expressions** | Execute code for debugging/captures |

#### Check Expressions

##### Plain text

Exact, case-sensitive matching.

```
This text should be here
```

#### Regular expressions

Similarly to plain text matching, one may check against regular expressions.

The TC language uses [Raku Regular Expressions](https://docs.raku.org/language/regexes).


constrains!!! 

- you should use Raku regepx in regexp: directives

- you should not enclose regular expression in quotes

- you should escape `%` with backslash, not with double quotes:

wrong:

```
regexp: "%"
```

right:

```
regexp: \%
```

WARNING!!!

Raku regular expressions are quite different from Perl regexps, please refer the documentation - https://docs.raku.org/language/regexes to correctly write them

Example:

Input:

    2019-04-01
    Name: Sparrow6
    App Version Number: 0.0.1

DSL:

    regexp: \d\d\d\d "-" \d\d "-" \d\d # date in format of YYYY-MM-DD
    regexp: "Name:" \s+ \w+ # name
    regexp: "App Version Number:" \s+ \d+ "." \d+ "." \d+ # version number
    
Output:

    [task check] stdout match <\d\d\d\d '-' \d\d '-' \d\d> True
    [task check] stdout match <'Name:' \s+ \w+> True
    [task check] stdout match <'App Version Number:' \s+ \d+ \. \d+ \. \d+> True

##### Matching multiline strings

Check expressions match text in _line by line_ ( aka single line ) mode, there is no way 
to match multiline strings ( but see sequence expressions ).
    
For instance following check fails, even though regular expression is correct:

Input:

    A
    B
    
DSL:

    regexp: A \n B

But you can match consecutive series of lines using sequence expressions.

##### Regular expressions pitfalls

- Raku regular expressions are quite different from Perl regexps, please refer the documentation - https://docs.raku.org/language/regexes to correctly write them

- Multiline regular expressions ( unlike in Raku ) are prohibited. Following example of DSL is incorrect:

```
regexp: \d
\s
\d
```

This is correct form:

```
regexp: \d \s \d
```

If you need to write lengthy regular expression that does not fit your editor screen width, you can use generator: to split the expression by smaller chunks and generate final expression dynamically using one of the supported programming languages

Example:

```
generator: <<HERE
!raku
say "regexp: ", ("a" x 1000);
HERE
```

##### Following is a quick migration guide from Perl to Raku regexps

###### Spaces

In Raku spaces act differently then in Perl regexps. 

1) If you want to check against spaces you either use `\s+` or `" "`. 

Examples:

```
regexp: \s
# next regexp is equivalent to the previous one
regexp: " "

# also following two expressions
# are equivalent
regexp: "Hello World"
regexp: "Hello" \s "World"
```

2) we use spaces to separate chunks in complex regexp for *readability*, they never treated as spaces unless they are quoted  (see point number 1), for example:

```
regexp: "Bla" "Bla" \d
```

will match "BlaBla100" string

###### Quotes for alpha numeric strings

You don't need quotes for letters and numbers unless there is a space needed to match (see the spaces section):

```
# this all works without quotes

regexp: Hello 
regexp: ABC
regexp: 1977
```

Adding quotes for those elements, changes nothing, but readability.

Thus following expressions will do the same as the previous ones:

```
regexp: "Hello"
regexp: "ABC"
regexp: "1977"
```

###### Symbols that require escaping

`#` symbol has to be escaped by double quotes:

```
regexp: "#"
```

Following symbols need to be escaped via backslash if one want to match them:

```
-
%
~ 
: 
, 
@ 
* 
. 
! 
| 
/ 
\ 
- 
" 
' 
$ 
[ 
] 
( 
) 
+ 
= 
^ 
?
```
 
So to match "Hello:"

```
regexp: Hello\:
```

Other examples:

Wrong:

```
foo%password
```

Right:

```
foo\%password
```

Wrong:

```
foo-password
```

Right:

```
foo\-password
```

Wrong:

```
password!
```

Right:

```
password\!
```

###### Digits

```
note: 4 digits should be in stdout
regexp: \d\d\d\d
```

###### Digits and symbols

```
# match "Hello world"
# followed by date 
# in format MON.DD.YYYY
# where MON - month identified as 3 symbols
# for example JAN.01.2025

regexp: "Hello world" \s <[A..Z>]> ** 3 "." \d\d "." \d\d\d\d 
```

###### Mixing quotes and back slashes

When escaping symbols ,.+-:,= choose either double quote or back slash, but not both for readability:

```
# legid, but not necessary
# to use both \ and " for
# escaping of .
regexp: "\.hello"

# following two expressions
# do the same:

# escaping by back slash
regexp: \.hello

# escaping by quotes
regexp: ".hello"

```

###### Zero or more symbols

```
# 0 or more A
regexp: A*
```

###### One or more symbols

```
# One or more A
regexp: A+
```

###### Strictly N symbols

```
# only four A
regexp: A ** 4
```

```
# From two to four A
regexp: A ** 2..4
```

###### Any symbol, no symbols at all

```
# you can use regexp form:
regexp: .*
# or this form:
:any:
```

###### Beginning of string 

Use `^^` for beginning:

```
regexp: ^^ "Here we begin"

# or with zero or many
# leading spaces

regexp: ^^ \s* "Look ma at my tabs"

```

###### End of string

Use `$$` for end of string:

```
regexp: "wait until the end" \s* $$
```

See also https://docs.raku.org/language/regexes#Quantifiers

###### Symbol ranges

Instead of writing `[a-z]` like in Perl, use this form:

```
# anything from a to z
regexp: <[a..z]>
```

```
# anything from a to z, repeated 3 times
regexp: <[a..z]> ** 3
```

```
# anything from a to z, repeated from 1 to 3 times
regexp: <[a..z]> 1 ** 3
```

See also https://docs.raku.org/language/regexes#Enumerated_character_classes_and_ranges

##### Alternations

Alternations allows to match from many possible options:

```
# should be at least something
# out of three colors:
regexp: red || green || blue
```

To separate alternations from other regexp terms use square brackets:

```
regexp: "hello, mister" \s [ Red || Green || Brown ] "," \s "would you like a" \s [ tea || coffee ] "?"
```

See also [Alternations](https://docs.raku.org/language/regexes#Alternation:_||)

#### Assert Expressions

Asserts expressions are statements that are true or false.

False assert statement always results in task check failure.

Assert expression should be written in form:

`assert: {value} {short description}`

value should be one of the following

- 1
- true
- True
- 0
- false
- False

1, true, True are used for true assert statements,

0, false, False for false assert statements.

The second short description parameter of assert expression used for informative purposes, so it's just printed in report

Assert expression examples:

DSL:

    assert: 1 this is true
    assert: 0 this is false
    assert: True this is also true, Raku style 
    assert: False this is false, Raku style 
    assert: true this is true, python/ruby style 
    assert: false this is false, python/ruby style 

Output:

    [task check] <this is true> True
    [task check] <this is false> False
    [task check] <this is also true, Raku style> True
    [task check] <this is false, Raku style> False
    [task check] <this is true, python/ruby style> True
    [task check] <this is false, python/ruby style> False
    
Asserts are almost always created dynamically with generators. See the next section.

##### Asserts expressions pitfalls

- Strictly follow expression value format, should be on of the following - 1,true,True,0,false,False If the value is incorrect or empty task check parser will treat it as plan text check expression, following are some incorrect assert expressions examples:

```
# wrong format of assert value
assert: OK this never works

# empty assert value:
assert: ok
```

- When generating assert expressions via generators follow programming languages documenatation on how to convert language native types into assert expression value format

##### Check expressions pitfalls

If a check expression check fails it does not terminate the whole scenario straight away, the failed checks is marked in internal state and will result in whole scenario failure when scenario is finished.

So it's wrong to assume if we reach the end of task.check there is no check
failures

In other words even though a check is failed parser mark it state as failed and goes to the
next check

#### Matched data and capturing

Don't do that inside code: or generator, it wrong!

```
generator: <<HERE
!raku
my $input = slurp();
my @lines = $input.lines;
HERE
```

Instead use `capture()`, `captures()` or `matched()` functions, see later:

```
generator: <<HERE
!raku
for captures() -> $c {
    my $name = $c[0];
    my $v =  $c[1];
}
HERE
```

* Parser matches all the lines of input text against check expression

* If at least _one line_ matches a check expression - check step is considered as successful

* Matched lines are captured and accumulated inside matched array and available through `matched()` function wich returns list of matched strings:

```
generator: <<HERE
!raku
for matched() -> $m {
}
HERE
```

* If regular expressions use [capturing](https://docs.raku.org/language/regexes#Capturing), the respected captures are kept inside `captures` array and available through `capture()` and `captures()` functions, say we have input in following format:

```
key1 = value1
key2 = value2
```

Following code will capture all key/value pairs:

```
regexp: (\w+) \s+  '=' \s+ (\w+)
generator: <<HERE
!raku
for captures() -> $c {
    my $key = $c[0];
    my $value = $c[1];
}
HERE
```

`capture()` function returns the very first element of captures() list and works well
when you there only one matched occurrence 


***Layer***

Layer represents all captures for a single check step, if checks are applied within
search modifiers (between:, within:, begin:) there maybe more then one layer - one layer per
group, see also streams

Examples:

Input:

    1 - for one
    2 - for two
    3 - for three

DSL:

    regexp: (\d+) \s+ '-' \s+ for \s+ (\w+)
    
    code: <<CODE
    !perl
    
    use Data::Dumper; 
    
    print Dumper(captures());
    
    CODE
    
Output:

    [task check] stdout match <(\d+) \s+ '-' \s+ for \s+ (\w+)> True
    [task check] $VAR1 = [
    [task check]           [
    [task check]             '1',
    [task check]             'one'
    [task check]           ],
    [task check]           [
    [task check]             '2',
    [task check]             'two'
    [task check]           ],
    [task check]           [
    [task check]             '3',
    [task check]             'three'
    [task check]           ]
    [task check]         ];
    

Likewise `matched()` function return array of matched lines:

For the same input:

DSL:

    regexp: \d
    
    code: <<CODE
    !perl
    
    use Data::Dumper; 
    
    print Dumper(matched());
    
    CODE
    
Output:

    [task check] stdout match <\d> True
    [task check] $VAR1 = [
    [task check]           '1 one',
    [task check]           '2 two',
    [task check]           '3 three'
    [task check]         ];
    
The difference between `matched` and `captures()` is that `matched()` returns array of matched lines, while `captures()` returns array of _captured_ variables for _every_ matched line ( that means array of arrays ), _if_ regular expression has [capturing](https://docs.raku.org/language/regexes#Capturing);

In case there is no capturing in regular expression or plain strings check used `captures()` is equivalent of `matched()`

`capture()` function returns first element of the `captures()` array.

You can do more with captured data then just dumping it out. One of the common cases is to _compare_ captures with certain values, using _asserts_. Add this code to the previous example:

DSL:

    generator: <<CODE
    !perl
      print "assert: ", captures()->[0]->[0] == 1 ? 1 : 0, " captures0,0 == 1\n";
      print "assert: ", captures()->[0]->[1] eq 'one' ? 1 : 0, " captures0,1 == one\n";
      
      print "assert: ", captures()->[1]->[0] == 2 ? 1 : 0, " captures1,0 == 2\n";
      print "assert: ", captures()->[1]->[1] eq 'two' ? 1 : 0, " captures1,1 == two\n";
      
      print "assert: ", captures()->[2]->[0] == 3 ? 1 : 0, " captures2,0 == 3\n";
      print "assert: ", captures()->[2]->[1] eq 'three' ? 1 : 0, " captures2,1 == three\n";
      
      print "assert: ", capture()->[0] == 1 ? 1 : 0, " capture0 == 1\n";
      print "assert: ", capture()->[1] eq 'one' ? 1 : 0, " capture1 == one\n";
    
    
    CODE
    
And run check:

    [task check] <captures0,0 == 1> True
    [task check] <captures0,1 == one> True
    [task check] <captures1,0 == 2> True
    [task check] <captures1,1 == two> True
    [task check] <captures2,0 == 3> True
    [task check] <captures2,1 == three> True
    [task check] <capture0 == 1> True
    [task check] <capture1 == one> True
    

That allows you to write tests in Perl5 Test::More `cmp_ok` way.

`matched()`, `captures()` and `capture()` are defined for all DSL compatible languages.

Matched data and captures are reset for every check step, meaning that the related functions return data for the _last_ check step.

But also see streams, that accumulated captures within search context.

##### Capture(), captures(), matched() pitfalls

Captured or matched data is discarded with the next check expression.

In other words capture(), captures(), matched():

***All those functions only store data matched or captured for the last check expression***

They don't accumulate data for the previous checks.

Consider this example:

Input:

```
1 hello
2 world
```
DSL:

```
regexp: \d \s hello
regexp: \d \s world

code<< CODE
!raku
for matches()<> -> $l {
   say $l
}
```

This will only print `2 world` as this is a line where the last check expression matched

If you want to accumulate matched or captured data consider using within:, between: or begin: together with streams(), streams_array() functions. Streams always accumulate matches data when used together with mentioned search scope modifiers

So as a rule use code: or generator: expression after every check expression to handle captured, matched data:

```
regexp: \d
code: <<CODE
!raku
# handle matched data
CODE

regexp: \w
code: <<CODE
!raku
# handle matched data
CODE
```

### Code & Generator Expressions

**Code expressions:** 

Execute code for debugging or data extraction. 

Start with `code:` marker followed by <<HEREDOCMARKER, 
the first line of code: block should be language identifier - !language 

```
code: <<HERE
!language
# code here
HERE
```

Example for Raku:

code: <<HERE
!raku
say "hello";
HERE


#### Code expressions

Code expressions are just pieces of generic language code gets inlined and executed during verification process.

Example:

Input:

    Hello

DSL:

    Hello
    code: <<CODE
    !perl
    print "hi there!\n";
    CODE
    Hello

Output:

    [task check] stdout match <Hello> True
    [task check] hi there!
    [task check] stdout match <Hello> True
    
Code expressions have no impact on verification process and could be used for debugging. 

Code expressions should start with `code:` marker, followed by <<HERE doc 
marker that defines the start of code block.

The very first line of code block should contain language identificator in form of `!language` to define programming language to be used to execute code block, for instance:

```
!python
```

More code expression examples:

## raku

    code:  <<HERE
    !raku
    say 'hi there!'
    HERE

## bash 

    code:  <<HERE
    !bash
    echo 'hi there!'
    HERE


## ruby

    code: <<CODE
    !ruby
    puts 'hi there!'
    CODE

Sparrow6 task API is available inside code expressions:

    code: <<CODE
    !perl
    my $foo = config()->{foo};
    CODE

Read [Sparrow6 Development Guide](https://github.com/melezhik/Sparrow6/blob/doc/documentation/development.md) on task API.

See also [generators](#generators) section on how dynamically create check expressions using various programming languages.

Code expressions could use all the functions provided by Sparrow Task SDK - https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md

For example to pass input parameter to code: block use config() function:

```
code: CODE
!python
from sparrow6lib import *
cfg = config()
a = cfg["a"]
CODE
```


##### Code expressions pitfalls

- Don't use `slurp()` inside generator: , use shared state or captures(), matched() instead

- Don't use code expressions to print another DSL expressions ( for instance - regexp:, generator:, code:, within:, begin:, between: , etc ) , this does not make a sence as DSL parser does not treat output from code: expressions as check rules, it just dumps the output as is. Instead use generator: to generate new check rules or DSL expressions

- Always set language identifier on the very first line of code block, or else default
language (Perl) will be applied which is not probably what you want

- For code expressions written on Python if Sparrow SDK functions are used ( matched(), captures(), capture(), streams-array(), config(), os(), get_state(), update_state(), etc ) you have to import those functions from sparrow6lib to make them available inside code expression block:

```
code: <<CODE
!python
from sparrow6lib import *
c = capture()
conf = config()
CODE
```

**Generator expressions:** 

Dynamically generate DSL rules. 

Output printed to stdout is parsed as new DSL code.

Start with `generator:` marker followed by <<HEREDOCMARKER, 
the first line of code: block should be language identifier - !language 


```
generator: <<HERE
!language
# code that prints DSL rules
HERE
```

Example for Raku:

code: <<HERE
!raku
say "regexp: hello";
HERE

Available API functions (all languages):
- `matched()` -- returns array of matched lines for the **last** check expression
- `captures()` -- returns array of arrays of captured variables per matched line
- `capture()` -- returns first element of `captures()` array
- `streams_array()` -- accumulates matches within search context modifiers

**Critical:** 

`matched()`, `captures()`, and `capture()` only store data for the **last** check expression. They do **not** accumulate across checks unless used with `within:`, `between:`, or `begin:` together with `streams()`/`streams_array()`.


#### Generators

* Generators is the way to _generate check expressions on the _fly_

* Generator expressions like code expressions are just pieces of executable code

* Everything that generator code print to _stdout_ is _treated_ as new DSL code and parsed by DSL parser

* So new DSL terms are passed back to DSL parser and executed immediately

Generator expressions should start with `generator:` marker, followed by <<HERE doc 
marker that defines the start of generator
block.

The very first line of generator block should contain language identificator in form of `!language` to define programming language
to be used to execute generator block, for instance:

```
!python
```

The end of generator block should be closed
by HERE doc marker. 

More generator examples:

Input text:

    HELLO

DSL:

    generator: <<CODE
    !perl
    print join "\n", ('H', 'E', 'L', 'O');
    CODE

Output:

    [task check] stdout match <H> True
    [task check] stdout match <E> True
    [task check] stdout match <L> True
    [task check] stdout match <O> True
    
Here are examples for other languages:

Input text:
    
    Say
    Hello
    First
    
This generator creates 3 new check expressions:

Bash:

    generator: <<CODE
    !bash
      echo Say
      echo Hello
      echo 'regexp: Hello || Again'
    CODE

Ruby:

    generator: <<CODE
    !ruby
      puts 'Say'
      puts 'Hello'
      puts 'regexp: Hello || Again'
    CODE

Output:

    [task check] stdout match <Say> True
    [task check] stdout match <Hello> True
    [task check] stdout match <Hello || Again> True

Here is more complicated example of using Perl language.

Input:

    foo value
    bar value

DSL:

    # this generator creates
    # comments
    # and plain string 
    # check expressions

    generator: <<CODE
    !perl
     my %d = ( 'foo' => 'foo value', 'bar' => 'bar value' );
    
     print join "\n", map { ( "# $_ ", $d{$_} ) } keys %d;
      
    CODE
    
Output:

    [task check] stdout match <bar value> True
    [task check] stdout match <foo value> True
    
Generators could produce not only check expressions but code expressions and another generators.

Generators are often used to create an asserts from captures. 

This is short example for Ruby language:

    number: (\d+)
    
    generator: <<CODE
    !ruby
        puts "assert: #{capture()[0] == 10}, you've got 10!"  
    CODE

Generator expressions could use all the functions provided by Sparrow Task SDK - https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md

For example to pass input parameter to generator use config() function:

```
generator: CODE
!python
from sparrow6lib import *
cfg = config()
a = cfg["a"]
CODE
```

##### Generators pitfalls

- Don't use `slurp()` inside generator: , use shared state or captures(), matched() instead

- Always set language identificator on the very first line of generator block, or else default language (Perl) will be applied which is not probably what you want 

- For generator expressions written on Python if Sparrow SDK functions are used (matched(), captures(), capture(), streams-array(), config(), os(), get_state(), update_state(), etc you have to import those functions from sparrow6lib to make them available inside generator expression block:

- Don't print anything starting with `#` from generator: code, use `note:`, as anything started with `#` will be ignored by DSL parser

Example, don't do that:

```
generator <<RAKU
!raku
say "# debug message";
RAKU
```

instead do this:

```
generator <<RAKU
!raku
say "note: debug messages";
RAKU
```

```
generator: <<CODE
!python
from sparrow6lib import *
c = capture()
conf = config()
CODE
```

##### Sharing data between code or generator blocks

To share captured data across code: or generator: blocks use functions [update_state(), get_state()](https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md#task-states) provided by Sparrow Task SDK:

```
regexp: ID \: \s+ (\d+)

code: <<CODE
!raku
if matched() {
   update_state(%(
     id => capture()[0]
   ));
}
CODE

regexp: Name \: \s+ (\S+)

code: <<CODE
!raku
if matched() {
   my $id = get_state()<id>;
   my $name = capture()[0];
   say "{$name}'s ID is {$id}";
}
CODE

```

###### get_state(), update_state() pitfalls

SDK function  `get_state()`  should not accept any arguments it return state.  
update_state(state) SDK function should accept state as argument. Please take this into account,when saving state inside multiple code: generator: always get current state first via get_state(),
and add new fields/objects to this current state, then save whole updated state:

```
code: <<HERE
!raku
my $s = get_state();

$s<new-field> = %(
    data => [1,2,3]
);

update_state($s);
HERE
```



### Search Context Modifiers

**Sequence expressions:** 

Match consecutive lines in order. Must be enclosed in `begin:`/`end:` markers:

```
begin:
  line1
  line2
  line3
end:
```

📇️ You cannot skip blank lines in sequences. Sequence blocks cannot be nested.

**Range expressions:** 

Match lines between two delimiters using `between: {start} {end}`:

```
between: {foo} {bar}
  regexp: pattern
end:
```

⚠️ Ranges verify lines are *within* bounds, not necessarily consecutive. Nesting ranges is not supported.

**Within expressions:** 

Narrow search context to lines matching a pattern. Requires `end:` to restore context.

### Pitfalls & Best Practices

1. **Always use `end:` to close context modifiers.** Forgetting `end:` leaves the parser in modified context indefinitely.

2. **Raku regex spaces:** In DSL regex, spaces separate tokens for readability. Quote them or use `\s` to match literal spaces.

3. **Don't use `code:` to print DSL expressions.** Use `generator:` instead; `code:` output is not parsed as rules.

4. **Failures accumulate.** One failed check doesn't stop execution; all checks run.

5. **Captures reset per check.** Use `within:`/`begin:` with `streams()` for accumulated data.

6. **Assert format strictness.** Invalid assert values become plain text checks, not assertions.



# Negations

Negations are reverse matches, they work the same way as regular expressions 
but with reverse logic - if text matches - check fails.

Here are some examples:

Input:

```
OK
Hello
done
A B C D
```

DSL:

```
note: negations in blocks

begin:
regexp: OK
!regexp: ok
Hello
done
end:

note: negations for single strings
!regexp: Ok

note: negations inside ranges
note: between: {OK} {done}
between: {OK} {done}
  !regexp: HELLO
  Hello
end:

within: "A B"
!regexp: F
C
end:
```

output:

```
[task check]
# negations in blocks
stdout match (s) <OK> True
stdout match (s) <!ok> True
stdout match (s) <Hello> True
stdout match (s) <done> True
# negations for single strings
stdout match <!Ok> True
# negations inside ranges
# between: {OK} {done}
stdout match (r) <!HELLO> True
stdout match (r) <Hello> True
stdout match (w) <!F> True
stdout match (w) <C> True
```

# Search by line numbers AKA SLN search

Sometime it makes a sense to search by line number of text output. 

Task check provides SLN ( Search by Line ) exprrssions for that. SLN expression is in form:

colon line number colon


Where line number is a number of line of input text.

There should not be any spaces between line 
number and colons. 

Examples:

```
# the very first line
# line number 0
# internally input starts with 0
# index

:0:


# line number 99

:99:
```

Full example:

Input:

```
OK
HELLO
OK
DONE
BYE!
```

DSL:

```
OK

code: <<RAKU
!raku
use Data::Dump;
for captures-full() -> $s {
  say $s;
}
RAKU


begin:
HELLO
!regexp: OK2
:2:
!regexp: OK3
:3:
BYE!
end:
```

Output:

```
[task stdout]
13:02:02 :: OK
13:02:02 :: HELLO
13:02:02 :: OK
13:02:02 :: DONE
13:02:02 :: BYE!
[task check]
stdout match <OK> True
# [{data => [OK], index => 0, stream-id => (Any)} {data => [OK], index => 2, stream-id => (Any)}]
stdout match (s) <HELLO> True
stdout match (s) <!OK2> True
stdout match (s) <:2:> True
stdout match (s) <!OK3> True
stdout match (s) <:3:> True
stdout match (s) <BYE!> True
```

The search starts with "OK" lines check that find two lines. The first is at the index 0, 
and the second at the index 2.

Next sequential search begins with "HELLO" line (the one and only here), then references to 
the second "OK" line (at the index number 2), and then to the line with index number 3 (which happens to be a "DONE" line), that all results in effective search of `HELLO->OK->DONE->BYE!` sequential block.

Additional negation checks make it sure that there is no "OK2" line after the first "HELLO" line, and there is no "OK3" line after the second "OK" line.

---

You can use SLN in ranges, sequential blocks and  within expressions:

```
note: search everything between 1st and 3d lines
between: { :1: } { :3: }
    regexp: .*
end:
```

```
note: start sequence from 2nd line
begin:
    :2:
    hello2
end:

note: search within line number 33
within: :33:
end:
```

## SLN expressions pitfalls

- When using SLN expressions, there should not be any other symbols before or after exprrssion ( with the exception of using SLN together with between: and within: , see the next paragaphs ).

Following example of correct SLN expressions
used with other expressions:

```
# verify that input text
# has the very first
# hello line
# then any line
# the world line
# then any line 
hello
:1:
world
:3:
```

This is example of incorrect SLN expressions
syntax when SLN expressions are used with other expressions:

```
# this is wrong
# you cannot use SLN and other
# expressions on the same line
helld
:1: world :3:
```

- You can use SLN expressions together with
between expressions like that ( previous rule of no other expressions on the same line where SLN is written does not apply ) 

```
# verify that input text
# between the first
# and tenth line
# has digits
between: { :0: } { :9 }
regexp: \d
end:
```

```
# verify that input text
# between the first
# and line with word DONE
# has digits
between: { :0: } { DONE }
regexp: \d
end:
```

- You can use SLN expressions together with within; expressions like that ( previous rule of no other expressions on the same line where SLN is written does not apply ) 

```
# verify that input text
# tenth line
# has digits
within: :9:
regexp: \d
end:
```

- In task check parser line numbers starts with index 0, so the first line will be :0:,
the second will be :1:, etc

# Streams

Streams are captures grouped by logical blocks within search context.

While captures and  matched lines get flushed with every check step, steams allow to _accumulate_ captures and group them.

Consider an example with captures first:

Input text:

    foo
        a
        b
        c
    bar

    foo
        1
        2
        3
    bar

    foo
        0
        00
        000
    bar

DSL code:

    begin:

      regexp: (f) (oo)
  
      code: <<CODE
      !perl
      print "layer: 1 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
      CODE
      
      regexp: (\S+)
  
      code: print "layer: 2 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
  
      regexp: (\S+)
  
      code: <<CODE
      !perl
      print "layer: 3 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
      CODE
      
      regexp: (\S+)
  
      code: <<CODE
      !perl
      print "layer: 4 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
      CODE
      
      regexp: (bar)
  
      code: <<CODE
      !perl
      print "layer: 5 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
      CODE
      
    end:
    
Output:

    [task check] stdout match (s) <(f) (oo)> True
    [task check] layer: 1 {f}{oo}{f}{oo}{f}{oo}
    [task check] stdout match (s) <(\S+)> True
    [task check] layer: 2 {a}{1}{0}
    [task check] stdout match (s) <(\S+)> True
    [task check] layer: 3 {b}{2}{00}
    [task check] stdout match (s) <(\S+)> True
    [task check] layer: 4 {c}{3}{000}
    [task check] stdout match (s) <(bar)> True
    [task check] layer: 5 {bar}{bar}{bar}
        

As we've seen though this example:

* With captures it's impossible to preserve previously matched data and group it by streams ( abc, 123, 0 00 000 ).

* Captures scope is always limited to check step

* Captures are grouped by check steps

* Captures are logical groups ignorant

Streams act differently, they respect search context and logical groups:

* Streams are grouped by search context logical blocks

* Streams allow to accumulate matched data within search context

Consider the same example with streams:

DSL:

    begin:

      regexp: (f) (oo)
      regexp: \S+
      regexp: \S+
      regexp: \S+
      regexp: (bar)

      code:  <<CODE
      !perl
        for my $s (@{streams_array()}) {
            my $i=1;
            for my $l (@{$s}){
              print "layer: ", $i++, " ", (join "", map {"{$_}"} @{$l}), "\n";
            }
          print "\n";
        }
  
      CODE
  
    end:


Output:

    [task check] layer: 1 {f}{oo}
    [task check] layer: 2 {a}
    [task check] layer: 3 {b}
    [task check] layer: 4 {c}
    [task check] layer: 5 {bar}
    [task check] 
    [task check] layer: 1 {f}{oo}
    [task check] layer: 2 {1}
    [task check] layer: 3 {2}
    [task check] layer: 4 {3}
    [task check] layer: 5 {bar}
    [task check] layer: 1 {f}{oo}
    [task check] 
    [task check] layer: 1 {f}{oo}
    [task check] layer: 2 {0}
    [task check] layer: 3 {00}
    [task check] layer: 4 {000}
    [task check] layer: 5 {bar}
        
In this example `stream_array()` function returns an array of _streams_. 

Every stream is an array of _layers_, where layer is captured data for a single check step within search context logical block

Streams preserve logical block context. Number of streams relates to the number of successfully matched blocks.

Streams data presentation is much closer to what we see in original text, because it remain original text structure,
not breaking it to independent layers.

Stream could be specially useful when combined with range expressions of _different_ range lengths:

Input text:

    foo
        2
        4
        6
        8
    bar

    foo
        1
        3
    bar

    foo
        0
        0
        0
    bar


DSL code:

    between: {foo} {bar}
    
      regexp: (\d+)
    
      code:  <<CODE
      !perl
        for my $s (@{streams_array()}) {
            my $i=1;
            for my $l (@{$s}){
              print "layer: ", $i++, " ", (join "", map {"{$_}"} @{$l}), "\n";
            }
          print "\n";
        }
    
      CODE
    
    end:
    
Output:

    [task check] stdout match (r) <(\d+)> True
    [task check] layer: 1 {2}
    [task check] layer: 2 {4}
    [task check] layer: 3 {6}
    [task check] layer: 4 {8}
    [task check] 
    [task check] layer: 1 {1}
    [task check] layer: 2 {3}
    [task check] 
    [task check] layer: 1 {0}
    [task check] layer: 2 {0}
    [task check] layer: 3 {0}

## Streams functions

Following streams functions are implemented for TC compatible languages:

* streams_array

Returns array of streams

* streams()

Hash representation of streams data. Hash keys - unique stream identifiers.

* dump_streams()

Dump streams in human readable format, useful for debugging.

# Experimental features

## Replace

Replace allows to update file in runtime during check is performed

Following example search HELLO and digits within OK .. DONE range and then 
increment found digit and update original file: 

Input file:

```
cat << HERE > file.txt
OK
HELLO 1
DONE
HERE
```

DSL:

```
between: {OK} {DONE}
    ~regexp: HELLO \s+ (\d+)
end:

code: <<RAKU
!raku
if matched() {
    my $ln = captures-full()[0]<index>;
    my $num = capture()[0].Int;
    $num++;
    replace("file.txt",$ln,"BYE $num");
}
RAKU
```

Modified file:

```
OK
BYE 2
DONE
```

Pay attention that [soft check](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskchecks.md#soft-checks) is used here to let main flow continues even though if
range search fails 

## Remove line

`remove-line` works similarly to `replace`, but just removing line at number `n`, following example
removes all lines between `AAA` and `BBB`, including `AAA` and `BBB` lines:

DSL:

```
between: {AAA} {BBB}
:any:
end:

code: <<RAKU
!raku
for captures-full()<> -> $c {
    remove-line("file.txt",$c<index>)
}
RAKU
```

## Sources

By default STDOUT is a source where input data is read from. One can charge this by using `source:` directive.

Consider two files - `file1.txt` and `file2.txt` with various content. Instead of checking content of _both_ files ( using  for example `cat file1.txt; cat file2.txt`), we can check files independently:

DSL:

```
source: file1.txt
# all checks are going to be against file1.txt
# data
A1
B1
C1

source: file2.txt
# all checks are going to be against file2.txt
# data
A2
B2
C2
```

This makes a sense when `file1.txt` has a following lines:

```
A1
B1
C1
```

And file `file2.txt` respectively:

```
A2
B2
C2
```

This is just a very _simple_ example showing the concept, one can do more sophisticated scenarios, for example
combining sources with code blocks:

```
# collect all lines with numbers
# capturing numeric data

~regexp: (\d+)

# save numbers to the file
# numbers.out for
# further processing

code: <<OK
!raku

my @data;

for captures()<> -> $c {
    push @data, $c[0];
}

"numbers.out".IO.spurt(@data.join("\n"));

OK

source: numbers.out

# capture all lines
:any:

# sum all numbers
code: <<OK
!raku

my $sum = 0;

for matched() -> $c {
    $a += Int($c)
}

say "sum: $sum";

OK
```

This scenario effectively implements linux style pipeline, where the first step extracts all the numbers and the second sums them up.


Sources could be effectively combined with `replace` and `remove-line` functions effectively causing reload of data from changed files, consider this example with a failure in the end, proving that the second line has already been deleted:

DSL:

```
note: === change source ===

source: /tmp/file1.txt
regexp: ^^ A1 $$
B1
C1

note: === change source ===

source: /tmp/file2.txt
regexp: ^^ A2 $$
B2
C2


note: === remove second line from /tmp/file1.txt  ===

code: <<OK
!raku
remove-line("/tmp/file1.txt",1)
OK

note: === change source ===

source: /tmp/file1.txt

B1
```

Output:

```
[task stdout]
|> source changed to [/tmp/file1.txt]
21:46:52 :: A1
21:46:52 :: B1
21:46:52 :: C1
|> source changed to [/tmp/file2.txt]
21:46:52 :: A2
21:46:52 :: B2
21:46:52 :: C2
|> source changed to [/tmp/file1.txt]
21:46:54 :: A1
21:46:54 :: C1
[task check]
# === change source ===
stdout match <^^ A1 $$> True
stdout match <B1> True
stdout match <C1> True
# === change source ===
stdout match <^^ A2 $$> True
stdout match <B2> True
stdout match <C2> True
# === remove second line from /tmp/file1.txt  ===
# === change source ===
stdout match <B1> False
```

# FAQ

## Q1

> Is it common for one line to fail and subsequent lines then fail even though they match?

This only happens if sequential search is used, for example:

task.check
```
begin:
AAA
B
C
end:
```
Report:
```
[task stdout]
23:17:57 :: A
23:17:57 :: B
23:17:57 :: C
[task check]
stdout match (s) <AAA> False
stdout match (s) <B> False
stdout match (s) <C> False
=================
TASK CHECK FAIL
```

This happens because for `block:` `end:` mode, search effectively stops when the first none matching happens, because all the *further* matches do not matter as we require subsequent match - like AAA, B, C in strict order.


# Examples

Following are some selected use cases,
for more go to examples/ directory

## Apache version

DSL:

```
regexp: ^^ \s* "Server:" \s+ "Apache/" \d+ "."
```

Output:

```
[task stdout]
22:14:15 :: Server: Apache/2.4.62
[task check]
stdout match <^^ \s* "Server:" \s+ "Apache/" \d+ "."> True
```
---

## Raku Regex Quick Reference

### Basic Syntax

**Anonymous regex:**
```raku
/pattern/             # shorthand
rx/pattern/           # explicit
regex { pattern }     # keyword-declared
```

**Named regex:**
```raku
regex R { pattern }   # named Regex object
token R { pattern }   # implies :ratchet
rule R { pattern }    # implies :ratchet :sigspace
```

**Matching:**
```raku
"string" ~~ /pattern/     # smartmatch
m/pattern/                # explicit match against $_
"string".match(/pattern/) # method form
```

### Character Classes

**Predefined:**
| Class | Description |
|----------------------------------------------------------------------------|
| `<alpha>` | Alphabetic + underscore |
| `<digit>` or `\d` | Decimal digits |
| `<xdigit>` | Hex digits [0-9A-Fa-f] |
| `<alnum>` | `<alpha>` + `<digit>` |
| `<punct>` | Punctuation & symbols |
| `<space>` or `\s` | Whitespace |
| `<cntrl>` | Control characters |
| `<lower>` / `<:Ll>` | Lowercase |
| `<upper>` / `<:Lu>` | Uppercase |
| `<|wb>` | Word boundary |
| `<ww>` | Within word |

**Enumerated classes:**
```raku
<[abc]>        # match a, b, or c
<-[abc]>       # negated: any except a, b, c
<[a..z]>       # range
<[\d] - [13579]>  # set difference
```

**Unicode properties:**
```raku
<:Script<Latin>>    # Unicode script
<:Block('Basic Latin')>  # Unicode block
```

### Quantifiers

| Quantifier | Meaning |
|------------------------------------|
| `+` | One or more |
| `*` | Zero or more |
| `?` | Zero or one |
| `** N` | Exactly N times |
| `** M..N` | Between M and N times |
| `** M..*` | At least M times |

### Captures & Grouping

**Positional captures:**
```raku
/(\d+)/        # captured into $0
/(\d+) (\w+)/  # $0, $1
```

**Named captures:**
```raku
/$<year>=(\d{4})/  # accessible as $<year>
/<alpha>/           # also captures into named capture
```

**Non-capturing grouping:**
```raku
[pattern]       # group without capturing
```

### Adverbs & Modifiers

| Adverb | Effect |
|-----------------------------------------------|
| `:i` or `:ignorecase` | Case insensitive |
| `:r` or `:ratchet` | No backtracking |
| `:s` or `:sigspace` | Whitespace significant |
| `:g` or `:global` | Match globally |
| `:ov` or `:overlap` | Overlapping matches |
| `:ex` or `:exhaustive` | All possible matches |

### Common Patterns

```raku
# Date YYYY-MM-DD
\d ** 4 '-' \d ** 2 '-' \d ** 2

# Quoted string
'"' <-[ " ]> * '"'

# Word with optional plural
\w+ s?

# Logical newline
\n

# Any character including newline
\N

# Match start/end of string
^  $   # line boundaries
^^ $$  # logical line boundaries (for multiline)
```

## Integration Guidelines

When using this skill for Sparrow6 task check files:

1. **Always verify Raku regex compatibility.** Remember that Raku regex differs from Perl/PCRE in significant ways:
   - Spaces are **not** matched literally
   - No `\n` in regex patterns within DSL (use sequence expressions for multiline)
   - Use `\s+` or `" "` for whitespace

2. **Structure task.check files with proper context management:**
   - Start with plain text or regex checks
   - Use `begin:/end:` for sequences, `between:/end:` for ranges
   - Place `code:` or `generator:` after check expressions to handle captures
   - Always close context modifiers with `end:`

3. **Debugging approach:**
   - Use `code:` expressions to dump `matched()`, `captures()` data
   - Verify each check expression independently before combining
   - Remember that failures don't halt execution; check all results

4. **Performance considerations:**
   - Generator expressions re-execute for each input line; keep them efficient
   - Use `streams_array()` for accumulating data within context modifiers
   - Prefer plain text checks over regex when exact matching suffices

