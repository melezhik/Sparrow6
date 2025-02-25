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
 :template_dir<examples>,
 :template<greetings>,
);

say %state<status>;


my %state2 = template6 "foo/server2.conf", %(
 vars => %(
  :name<Sparrow2>,
  :language<Raku>,
 ),
 :template_dir<examples>,
 :template<greetings>,
);

say %state2<status>;

directory-delete "foo";
