# PowerShell example: register a user
$body = @{
    username = 'test'
    email = 'test@example.com'
    password = 'secret123'
    submit = 'Register'
}
Invoke-RestMethod -Uri http://localhost:5000/register -Method Post -Body $body
