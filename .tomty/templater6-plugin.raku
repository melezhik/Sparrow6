#!perl6 

=begin tomty
%(
  tag => "plugin"
)
=end tomty

directory "foo";

my %state = task-run "deploy server config", "template6", %(
 vars => %(
  :name<Sparrow>,
  :language<Raku>,
 ),
 :target<foo/server.conf>,
 :template_dir<examples>,
 :template<greetings>,
);

say %state<status>;


template6-create "foo/server2.conf", %(
 vars => %(
  :name<Sparrow2>,
  :language<Raku>,
 ),
 :target<foo/server2.conf>,
 :template_dir<examples>,
 :template<greetings>,
);

directory-delete "foo";
