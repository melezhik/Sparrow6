=begin tomty
%(
  tag => "s6"
)
=end tomty

bash "s6 --plg-run directory@path=foo,action=create+file@content=hello,target=foo/hello.txt";
directory-delete "foo";
