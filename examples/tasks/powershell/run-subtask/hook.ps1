$params = @{foo="Value1"}

run_task '01', -hash $params

set_stdout("hello from powershell")

