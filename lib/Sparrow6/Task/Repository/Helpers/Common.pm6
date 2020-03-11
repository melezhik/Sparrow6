unit module Sparrow6::Task::Repository::Helpers::Common;

role Role {

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

  method !target-exists ($target) {

    self!log("check if target exists", $target);

    my $url = $.url;
    
    if $url ~~ s/^ 'file://' // {

      "$url/$target".IO ~~ :e

    } else {

      die "target-exist for http repository is not supported yet"

    }  

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
