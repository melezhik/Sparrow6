# Go pipelines with Raku interfaces

TLDR; How to write pipelines on Golang with interfaces in Raku

---

So, let's say you're golang developer and want pure Go to write some CICD task:

`cat task.go`

```golang
package main

import "fmt"

func main() {
	fmt.Println("Hello, pipeline")
}

```

Go is cool, but there is one thing that makes it difficult to use in high level scenarios - its verbosity. Passing parameters to go tasks and return them back to main scenario takes some efforts and a lot of boilerplate code. It'd be good to keep main code concise and easy to read. 

[Rakulang](https://raku.org) in other hand is perfect language when it comes to munge data in and out, due it's extreme flexibility and expressiveness. 

In this post I am going to show how to embed golang tasks into CICD pipelines, with a little help of Sparrow framework.

---

Let's, first of all, modify our golang task code, new version will be:


`cat task.go`

```golang
package main

import (
  "fmt"
  "github.com/melezhik/sparrowgo"
)

func main() {

  type Params struct {
    Message string
  }

  type Result struct {
    Message string
  }

  var params Params

  // sparrowgo takes care about passing 
  // input parameters from Raku to Go
  sparrowgo.Config(&params)

  // read params from pipeline
  fmt.Printf("Task params: %s\n", params.Message)

  // return results back to pipeline 
  sparrowgo.UpdateState(&Results{Message : "Hello from Go"})

}
```

All we've done here is utilized Sparrowgo package that "convert" golang task into Sparrow task with a benefits of passing and returning data from and to Rakulang.  

---

Finally this os how our pipeline will look like, now it's Raku part:

```
#!raku

my $s = task-run ".", %(
  :message<Hello from Raku>
);

say "Result: ", $s<Message>;
```

---

High level design.

Now, once we have some prove of concept code in place, we can get a high level picture of what our pipeline system could look like:


```
      [ Raku scenario to pass and handle data in and out ]
        \                    \                     \          
      task.go -> result -> task.go -> result -> task.go -> ...
```

So, we have the best of two worlds - Raku to write scenarios with less of code and Golang to do all heaving lifting where performance and strict type checking is required. 
