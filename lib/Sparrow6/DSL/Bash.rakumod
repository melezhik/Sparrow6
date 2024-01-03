use v6;

unit module Sparrowdo::DSL::Bash;

use Sparrow6::DSL::Common;

multi sub bash ( $command ) is export { bash $command, %() };

multi sub bash ( $command, $user ) is export { bash $command, %( user => $user ) };

multi sub bash ( $command, %opts? ) is export {

    my $task_name = %opts<description> || $command;

    $task_name.=subst("\n"," NL ",:g);

    if $task_name.chars > 50 {
      $task_name = $task_name.substr(0, 50) ~ ' ...';
    }
    
    $task_name = "bash: $task_name";

    my %params = Hash.new;

    %params<command> = $command;

    %params<user> = %opts<user> if %opts<user>:exists;
    %params<debug> = %opts<debug>.Int if %opts<debug>:exists && %opts<debug>.^name eq 'Bool';
    %params<expect_stdout> = %opts<expect_stdout> if %opts<expect_stdout>:exists;
    %params<envvars> = %opts<envvars> if %opts<envvars>:exists;
    %params<cwd> = %opts<cwd> if %opts<cwd>:exists;

    task-run( $task_name, 'bash', %params );

}
