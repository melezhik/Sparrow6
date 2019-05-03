#push our @foo, "bar was here";

set_stdout(
    "bar done\n".task_var('VAR')."\n"
);
