$progressPreference = 'silentlyContinue'
Write-Host "==="
$r = (Invoke-WebRequest -URI https://jsonplaceholder.typicode.com/todos/1).Content | ConvertFrom-Json
Write-Host $r.title
Write-Host "==="
