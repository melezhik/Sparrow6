zef "fez", %( skip-test => True );

task-run "fez login", "fez-login", %(
  user => "melezhik",
  password => %*ENV<fez_password>
);
