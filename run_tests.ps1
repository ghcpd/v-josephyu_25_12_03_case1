# Test runner script for Flask User Management Application (Windows PowerShell)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Flask User Management - Test Runner" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if virtual environment is activated
if (-not $env:VIRTUAL_ENV) {
    Write-Host "Virtual environment not activated. Activating..." -ForegroundColor Yellow
    & ".venv\Scripts\Activate.ps1"
    Write-Host "✓ Virtual environment activated" -ForegroundColor Green
    Write-Host ""
}

# Check if pytest is installed
$pytestExe = Get-Command pytest -ErrorAction SilentlyContinue
if (-not $pytestExe) {
    Write-Host "ERROR: pytest is not installed." -ForegroundColor Red
    Write-Host "Install it with: pip install pytest" -ForegroundColor Yellow
    exit 1
}

# Run tests
Write-Host "Running tests..." -ForegroundColor White
Write-Host ""

pytest -v tests/test_app.py --tb=short
$testExitCode = $LASTEXITCODE

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan

if ($testExitCode -eq 0) {
    Write-Host "✓ All tests passed!" -ForegroundColor Green
} else {
    Write-Host "✗ Some tests failed. Exit code: $testExitCode" -ForegroundColor Red
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Test coverage report (optional):" -ForegroundColor Yellow
Write-Host "  pytest --cov=. --cov-report=html tests/" -ForegroundColor Gray
Write-Host ""

exit $testExitCode
