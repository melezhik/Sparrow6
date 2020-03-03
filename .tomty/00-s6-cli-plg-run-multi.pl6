bash "s6 --plg-run directory@path=/tmp/foo,action=create+file@content='hello world',target=/tmp/foo/hello.txt";
