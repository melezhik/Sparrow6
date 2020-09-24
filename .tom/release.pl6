# run `mi6 --keep release`
task-run "module release", "raku-utils-mi6", %(
  args => [
    ["yes","keep"], 
    %( next-version => "=0.0.29" ),
    "release",
  ]
);
