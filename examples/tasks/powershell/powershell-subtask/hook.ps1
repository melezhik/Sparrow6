$params = @{name="Alexey";message="hello"}  

run_task 'powershell', -hash $params 
