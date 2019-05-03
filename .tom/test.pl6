task-run "check json files", "json-lint", %( path =>  "{$*CWD}" );
bash "zef test .";
