unit module Sparrow6::Task::Repository::Helpers::Common;

role Role {

  method !set-sparrow-root () {

    my $root;

    if $.sparrow-root {
  
      $root = %*ENV<SP6_PREFIX> ?? "{$.sparrow-root}/{%*ENV<SP6_PREFIX>}".IO.absolute  !! $.sparrow-root.IO.absolute;

      unless $root.IO ~~ :e { 

        mkdir $root; 

        self!log("sparrow root directory created", $root);

      }

      self!log("sparrow root directory choosen", $root);

    } else {

      if %*ENV<HOME> {

        $root = %*ENV<SP6_PREFIX> ?? "{%*ENV<HOME>}/{%*ENV<SP6_PREFIX>}/sparrow6".IO.absolute !! "{%*ENV<HOME>}/sparrow6".IO.absolute;

        unless $root.IO ~~ :e {
          mkdir $root;
          self!log("sparrow root directory created", $root);
        }

        self!log("sparrow root directory choosen", $root);

      } else {

        $root = %*ENV<SP6_PREFIX> ?? "/var/data/{%*ENV<SP6_PREFIX>}/sparrow6".IO.absolute !!  "/var/data/sparrow6".IO.absolute;

        unless $root.IO ~~ :e {
          mkdir $root;
          self!log("sparrow root directory created", $root);
        }

        self!log("sparrow root directory choosen", $root);

      }

    }

    # cache directory as internal storage

    mkdir "{$root}/.cache";

    self.sparrow-root = $root;

  }


  method get-resource ($resource, $target) {


    self!log("get resource", $resource);

    my $url = $.url;
    
    if $url ~~ s/^ 'file://' // {
      self!log("copy $url/$resource to:", $target);
      copy("$url/$resource".IO,$target.IO);
    } else {
      self!log("GET", "{$.url}/{$resource}");
      my @cmd = "curl", "-s", "-f", "-L", "-k", "-o", $target, "{$.url}/{$resource}";
      self!log("run cmd:", @cmd);
      run @cmd;
    }  

    self!log("target file", $target);


  }

  method !put-resource ($resource, $target) {


    self!log("put resource", $resource);

    my $url = $.url;
    
    if $url ~~ s/^ 'file://' // {

      self!log("copy $resource to:", "$url/$target");

      copy($resource.IO,"$url/$target".IO);
    } else {
      self!log("PUT", "{$.url}/{$resource}");
      die "upload to http repository is not supported yet";
      # not implimented yet
      #my @cmd = "curl", "-s", "-f", "-L", "-k", "-o", $target, "{$.url}/{$resource}";
      #self!log("run cmd:", @cmd);
      #run @cmd;
    }  

    self!log("target file", $target);


  }

}
