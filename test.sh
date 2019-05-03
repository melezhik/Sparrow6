#!/bin/bash

st=0

perl6 -MSparrow6::DSL -e "say 'running tests for:' ~ os()" || st=1;

for i in $(ls examples/task-checks/*.pl6); do echo run $i; perl6 $i || st=1; echo; done; 

for i in $(ls examples/*.pl6); do echo run $i; 

  echo $i;

  if test $i = "examples/sudo.pl6"; then
    sudo env PATH=$PATH perl6 $i || st=1; 
  else
    perl6 $i || st=1; 
  fi  

done; 

for i in $(ls examples/sparrow6-repository-api/*.pl6); do echo run $i; perl6 $i || st=1; echo; done; 

for i in $(ls examples/dsl/*.pl6); do echo run $i; perl6 $i || st=1; echo; done; 

if test $st -eq 0; then
  echo all tests passed
else
  echo some tests failed
fi

exit $st

