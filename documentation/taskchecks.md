# Task Checks

Regexp based DSL to verify structured, unstructured text output.

# Glossary

## Input data

Any text ( structured or not ) to be verified.

An input text is parsed line by line and analyzed _mostly_ on per line basis.

Examples:

* html code
* xml code
* json 
* plain text
* emails
* http headers
* program languages code

## Task Check DSL

* Is a domain specific language to parse and verify _arbitrary_ text

* TC stands for Task Check, TC language is a Task Check Language

* Terms DSL is used as a short synonym for the TC language

* DSL code - a program code written on the TC language

* The TC language _could be thought_ of both imperative and declarative language

### Declarative way

Static rules - check expressions - that define verification.

### Imperative way

* Dynamically generated rules - check expressions - are generated in _runtime_ by using DSL compatible programming languages

* DSL compatible programming languages:
 
  * Raku
  * Perl5
  * Bash
  * Ruby
  * Python
  * Powershell

Sparrow6 provides an API implemented for compatible languages ( see `matched()`, `captures()`, `streams_array()` functions )

Most of examples below will be for Perl5, but the same applies for other compatible languages. 

## DSL parser

DSL parser is the program which:

* parses DSL code

* parses input data

* verifies input data ( line by line ) against check expressions ( line by line )

## Verification process

Verification process matches lines of input text against check expressions.

This is rough explanation of the algorithm:

* For every _check expression_ in a check expressions list:
  * Calculate current _search context_
  * Set the _check step_ status as `unknown`
  * For every _line_ in input text:
    * Calculate if the line matches _check expression_
    * If line matches then marks check step status as `succeeded`
    * Next line
  * End of lines loop
* If the check step status is `unknown`, then set check step status to `failed`
* Next check expression
* End of expressions loop

* Check if all check steps succeeded. 
* If all check steps succeeded then the overall check status is `success` otherwise is `failed`

## Search context

Verification process is taken in a _context_.

By default search context _is an original_ input text stream, which is also called default search context.

However search context could be changed by applying search context modifiers ( see sequence, range and within expressions ).

When search context gets applied _effective_ search context narrows down depending on search context logic. 

Search context is restored to default one every time when DSL parser meets `end:` marker,  see also sequence, range and within expressions.

## DSL Parser Implementation

* `Sparrow6::Task::Check` is Raku implementation of the TC language

* The document describes the TC language itself, rather then methods of `Sparrow6::Task::Check` class

* Read Sparrow6 tasks structure in the [Sparrow6 Development Guide](https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md) on how to create task checks using TC language.

Here is an example of verification of 2 lines of text against 2 check expressions:

Input:

    Hello
    My name is Sparrow6!

DSL:
    
    Hello
    regexp: My \s+ name \s+ is \s+ \S+
    
Output:

    [task check] stdout match <Hello> True
    [task check] stdout match <My \s+ name \s+ is \s+ \S+> True
    
Another example:

DSL:

    # there should be digits
    regexp: \d
    # and greetings
    regexp: hello \s+ \w+
  

# DSL syntax

The TC language consists of the following building blocks:

* Comments blank lines and here documents

* Check expressions

  * Plain strings

  * Regular expressions

  * Asserts

* Search context modifiers

  * Sequence expressions

  * Range expressions

  * Within expressions

* Generator expressions

* Code expressions

# Check expressions

Check expressions are patterns to match input data. 

For example:

Input:

    HELLO
    HELLO WORLD
    My birth day is: 1977-04-16

DSL:

    HELLO
    regexp: \d\d\d\d "-" \d\d "-" \d\d

Output:

    [task check] stdout match <HELLO> True
    [task check] stdout match <\d\d\d\d "-" \d\d "-" \d\d> True
    

There are two types of check expressions:

* [plain text expressions](#plain-text-expressions) 

* [regular expressions](#regular-expressions).

# Plain text expressions 

Plain text expressions are plain strings to match against input text:

DSL:

    This text should be here
    
Plain text expressions are case sensitive:

Input:

    I am OK


DSL:

    I am OK
    I am ok

Output:
    
    [task check] stdout match <I am OK> True
    [task check] stdout match <I am ok> False

    

# Regular expressions

Similarly to plain text matching, one may check against regular expressions.

The TC language uses [Raku Regular Expressions](https://docs.raku.org/language/regexes).

story.bash

    2019-04-01
    Name: Sparrow6
    App Version Number: 0.0.1

task.check

    regexp: \d\d\d\d "-" \d\d "-" \d\d # date in format of YYYY-MM-DD
    regexp: "Name:" \s+ \w+ # name
    regexp: "App Version Number:" \s+ \d+ "." \d+ "." \d+ # version number
    
output:

    [task check] stdout match <\d\d\d\d '-' \d\d '-' \d\d> True
    [task check] stdout match <'Name:' \s+ \w+> True
    [task check] stdout match <'App Version Number:' \s+ \d+ \. \d+ \. \d+> True


## Matching multiline strings

Check expressions match text in _line by line_ ( aka single line ) mode, there is no way 
to match multiline strings ( but see sequence expressions ).
    
For instance following check fails, even though regular expression is correct:

Input:

    A
    B
    
DSL:

    regexp: A \n B

But you can match consecutive series of lines using sequence expressions.

# Matched data and capturing

* Parser matches all the lines of input text against check expression

* If at least _one line_ matches a check expression - check step is considered as successful

* Matched lines are captured and accumulated inside @matched array and available through `matched()` function 

* If regular expressions with [capturing](https://docs.raku.org/language/regexes#Capturing) are used, 
the respected captures get _accumulated_ inside `@captures` array and available through `captures()` function

* Layer is captures for a single check step, see also streams

Examples:

Input:

    1 - for one
    2 - for two
    3 - for three

DSL:

    regexp: (\d+) \s+ '-' \s+ for \s+ (\w+)
    
    code: <<CODE
    
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
    
The difference between `matched` and `captures()` is that `matched()` returns array of matched lines, while
`captures()` returns array of _captured_ variables for _every_ matched line ( that means array of arrays ),
_if_ regular expression has [capturing](https://docs.raku.org/language/regexes#Capturing);

In case there is no capturing in regular expression or plain strings check used `captures()` is equivalent of `matched()`

`capture()` function returns first element of the `captures()` array.

You can do more with captured data then just dumping it out. One of the common cases is to _compare_ captures
with certain values, using _asserts_. Add this code to the previous example:

DSL:

    generator: <<CODE
    
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

# Comments, blank lines and here documents

Comments and blank lines are skipped by parser during checks execution, 
but may be added to a code for the sake of readability.

## Comments

Comment lines start with `#` symbol:

    # comments could take whole line, like here
    regexp: \d
    Hello World # or start after some check expression
    
## Blank lines

Blank lines are ignored.

DSL code:

    regexp: \d
    # following 2 blank lines
    # does not count
    # parser will script them

## Here documents

Here documents strings are used to embed code for generator and code expressions:

An example of validating that input contains date for yesterday:

    # check if input text has dates
    # formatted as  YYYY-MM-DD
    # and then check if the first date is yesterday
    
    regexp: date: (\d\d\d\d)-(\d\d)-(\d\d)
    
    generator:  <<CODE
      use DateTime;                       
      my $c  = captures()->[0];            
      my $dt = DateTime->new( year => $c->[0], month => $c->[1], day => $c->[2]  ); 
      my $yesterday = DateTime->now->subtract( days =>  1 );                        
      print 
        "assert: ",
        (DateTime->compare($dt, $yesterday) == 0) ? 1 : 0 , 
        " first day found is - $dt and this is a yesterday\n";
        
        
Read generator and code doc sections to know more about code and generators.

# Search Context Modifiers

SCM change verification logic, _altering_ search context which is by default is the input data.

SCM always narrows down search context making verification criteria more strict. 

There are three types of search context modifiers:

* Sequences ( aka text blocks ) expressions
* Ranges expressions
* Within expressions 

# Sequences

Sequences narrows down searched input data to the _consecutive_ sequence of lines, "insisting", that matched lines should go one by one:

Input:

    this string followed by
    that string followed by
    another one string
    with that string
    at the very end.

DSL:
    
    # this text block
    # consists of 5 strings
    # going consecutive

    begin:
        # plain strings
        this string followed by
        that string followed by
        another one
        # regexp patterns:
        regexp: with \s+  ( this || that ) 
        # and the last one in a block
        at the very end
    end:

Output:

    [task check] stdout match (s) <this string followed by> True
    [task check] stdout match (s) <that string followed by> True
    [task check] stdout match (s) <another one> True
    [task check] stdout match (s) <with \s+  ( this || that )> True
    [task check] stdout match (s) <at the very end> True
    

Letter `s` in parenthesis in output shows that search context changed to sequence.

A negative example:

Input:

    that string followed by
    this string followed by
    another one string
    with that string
    at the very end.
 
The same check will result in:
   
    [task check] stdout match (s) <this string followed by> True
    [task check] stdout match (s) <that string followed by> False
    [task check] stdout match (s) <another one> False
    [task check] stdout match (s) <with \s+  ( this || that )> False
    [task check] stdout match (s) <at the very end> False


Sequences caveats:

* `begin:`, `end:` markers denote start and end of a sequence. 

* Note, the markers should not be followed by any text at the same line.

* Be aware if you leave "dangling" `begin:` marker without closing `end:` parser will remain in sequence search context 
till the end of the file, which probably is not you want:

Example:

    begin:
        # sequence context starts here
        foo
        bar
        # and it will continue to the 
        # end of file
        # if we don't close it
        # through :end
    some-check # we still in `sequence search` context here

* You can't skip over blank lines in sequences expressions

Input:

    aaa
    bbb
    
    ccc
    
DSL:

    begin:
      aaa
      bbb
      ccc
    end:
    
Output:

    [task check] stdout match (s) <aaa> True
    [task check] stdout match (s) <bbb> True
    [task check] stdout match (s) <ccc> False
    
You need to match blank lines thought regexps:

    begin:
      aaa
      bbb
      regexp: ^^  $$
      ccc
    end:
     
# Range expressions

Range expressions also act like search context modifiers - they change search area to the one included
between lines matching right and left regular expression of between statement:

    between: {re1} {re2}

DSL parser uses Raku [^fff^](https://docs.raku.org/language/operators#infix_^fff^) operator to 
search within diapason.

It's technically equally to this Raku code:

    if /$re/ ^fff^ /$re2/

Thus, search context is narrowed down to the lines between line matching left regular expression and line matching right regular expression.

A matching (boundary) lines are not included in the range. 

Examples:

Parsing html output

Input:

    <table cols=10 rows=10>
        <tr>
            <td>one</td>
        </tr>
        <tr>
            <td>two</td>
        </tr>
        <tr>
            <td>the</td>
        </tr>
    </table>


DSL:

    # between expression:
    between: { '<table' .* '>' } { '</table>' }
      regexp: '<td>' (\S+) '</td>'
    end:
    
    # or even so
    between: { '<tr' .* '>' } { '</tr>' }
      regexp: '<td>' (\S+) '</td>'
    end:
    
Output:


    [task check] stdout match (r) <'<td>' (\S+) '</td>'> True
    [task check] stdout match (r) <'<td>' (\S+) '</td>'> True


## Range expressions caveats

* Resetting search context
        
As with sequences ranges expressions need to reset search context by using `:end` marker:

Input:

    foo
      hello
    bar

    hello
    hello

DSL:

    between: {foo} {bar}

      # all check expressions here
      # will be applied to the range
      # between /foo/ ^fff^ /bar/
  
      hello # should match 1 time
  
      generator: print "assert: ", ( scalar @{matched()} == 1 ? 1 : 0 ), " 1 hello within foo ... bar\n"; 
  
      # reset context, end of the range context:
  
    end:

    hello # should match three times

    generator: print "assert: ", ( scalar @{matched()} == 3 ? 1 : 0 ), " 3 hello within all document\n"; 

Output:

    [task check] stdout match (r) <hello> True
    [task check] <1 hello within foo ... bar> True
    [task check] stdout match <hello> True
    [task check] <3 hello within all document> True

* Range expressions can't verify continuous sequences.

That means range expression only verifies that lines are _inside_ a range, not necessarily in consecutive order.

Example:

Input:

    
    foo
        1
        a
        2
        b
        3
        c
    bar


DSL code:

    between: {foo} {bar}
       regexp: (1)
       code: print capture()->[0], "\n"
       regexp: (2)
       code: print capture()->[0], "\n"
       regexp: (3)
       code: print capture()->[0], "\n"
    end:

Output:

      [task check] stdout match (r) <(1)> True
      [task check] 1
      [task check] stdout match (r) <(2)> True
      [task check] 2
      [task check] stdout match (r) <(3)> True
      [task check] 3
      
If need to check consecutive sequences use sequence expressions.

* Nested ranges are not supported due to the nature of `^fff^` operator. 

The following example shows that:


Input:

    foo1
      foo2
        foo3
          foo4
        bar
      bar
    bar


DSL:

    between: {foo} {bar}
    regexp: (foo \d+)
    code: use Data::Dumper; print Dumper(captures());

Output:

    [task check] stdout match (r) <(foo \d+)> True
    [task check] $VAR1 = [
    [task check]           [
    [task check]             'foo2'
    [task check]           ],
    [task check]           [
    [task check]             'foo3'
    [task check]           ],
    [task check]           [
    [task check]             'foo4'
    [task check]           ]
    [task check]         ];
    

# Within expressions

Within expression narrows down search context to lines matched given regular expression

Text input:

    color: red    RE1
    color: green  GR1
    color: blue   BL1
    color: brown  BR1
    color: back   BL1
    color: red    RE2

DSL code:

    # I need one of 3 colors:

    within: color: ( red || green || blue )
      RE2
    end:


Output:

    [task check] stdout match (w) 'color:' \s+ ( red || green || blue ) <RE2> True

The code above does follows:

* Check input text against regular expression "color: ( red || green || blue ) "

* If check is successful new search context is set to all _matched_ lines

They are:

    color: red    RE1
    color: green  GR1
    color: blue   BL1
    color: red    RE2


* The next checks expression is executed against new search context and narrows downs to these lines only.

Within search context acts like chained _specifiers_. 

In other words this effectively means using `&&` logical operators for all check expressions inside within search context.

When you may start with some generic check and then make your requirements more specific. 

A failure on any more specific step means overall failure.


Input:

    2000-04-01

DSL:

    # date should be in format
    within:  \d\d\d\d '-' \d\d '-' \d\d
    
      # AND should be 2000 year
      regexp: ^^ '2000-'
    
        # AND should be the forth month
        regexp: '-04'
    
        # AND should be the first day
        01

    end:

Output:

    [task check] stdout match (w) <^^ '2000-'> True
    [task check] stdout match (w) <'-04'> True
    [task check] stdout match (w) <01> True


## Within expressions caveats

* Resetting search context
        
As with sequences and ranges, within expression need ending `end:` marker to restore search context.

# Code expressions

Code expressions are just pieces of generic language code gets inlined and executed during verification process.

Default language is Perl5:

Input:

    Hello

DSL:

    Hello
    code: print "hi there!\n";
    Hello

Output:

    [task check] stdout match <Hello> True
    [task check] hi there!
    [task check] stdout match <Hello> True
    
Code expressions have no impact on verification process and could be used for debugging. 

See also [generators](#generators) section on how dynamically create check expressions using programming languages.

The code language is defined in shebang on the first line of here document.

Examples:

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

Read [Sparrow6 Development Guide](https://github.com/melezhik/Sparrow6/blob/doc/documentation/development.md)
on task API.

# Asserts

Asserts expressions are statements that whether false or true depending on the value of first arguments
of assert "function":

    assert: $value $description

First value should be _something_ to be treated as false or true:

The second parameter of assert function is description - a short string to describe assert statement.

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
 

# Generators

* Generators is the way to _generate check expressions on the _fly_

* Generator expressions like code expressions are just pieces of executable code

* Everything that generator code print to _stdout_ is _treated_ as new DSL code and parsed by DSL parser

* So new DSL terms are passed back to DSL parser and executed immediately

Generators expressions start with `generator:` marker:

Input text:

    HELLO

DSL:

    generator: print join "\n", ('H', 'E', 'L', 'O');

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

# Negations

Negations are reverse matches, they work the same way as regular expressions 
but with reverse logic - if text matches - check fails.

Here are some examples:

task.bash

```
echo "OK"
echo "Hello"
echo "done"

echo "A B C D"
```

task.check

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
# negations for sinle strings
stdout match <!Ok> True
# negations inside ranges
# between: {OK} {done}
stdout match (r) <!HELLO> True
stdout match (r) <Hello> True
stdout match (w) <!F> True
stdout match (w) <C> True
```

# Search by line numbers AKA SLN search

Sometime it makes a sence to search by line number of text output. 

Conside this example:

task.bash

```
echo OK
echo HELLO
echo OK
echo DONE
echo BYE!
```

task.check

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

output

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

One can use SLN in ranges:

```
note: between 10th and 20nd line
between: :10 :20
```

And in within expressions:

```
note: within line number 33
within: :33:
```

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
  
      code: print "layer: 1 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
  
      regexp: (\S+)
  
      code: print "layer: 2 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
  
      regexp: (\S+)
  
      code: print "layer: 3 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
  
      regexp: (\S+)
  
      code: print "layer: 4 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
  
      regexp: (bar)
  
      code: print "layer: 5 ", ( join "", map { map {"{$_}"} @{$_}} @{captures()} ), "\n";
    
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

Hash representation of streams data. Hash keys - unique stream identeficators.

* dump_streams()

Dump streams in human readable format, useful for debugging.
        
# Examples

* Look at [examples](https://github.com/melezhik/Sparrow6/tree/master/examples) folder

# Environment variables

* SP6_DEBUG

Print out debug information.

* SP6_KEEP_CACHE

Don't remove cache files when checks are done. Useful when debugging.

# Author

[Aleksei Melezhik](mailto:melezhik@gmail.com)

# Home page

https://github.com/melezhik/Sparrow6

# COPYRIGHT

Copyright 2019 Alexey Melezhik.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

# See also

[Sparrow6 Development Guide](https://github.com/melezhik/Sparrow6/blob/master/documentation/development.md)

# Thanks

* To God as the One Who inspires me to do my job!



