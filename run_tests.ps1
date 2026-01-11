###############################################################################
# Flask User Management - Test Execution Script (PowerShell)
# This script runs the pytest test suite with various options
###############################################################################

# Enable strict mode
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flask User Management - Test Suite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if virtual environment exists
if (-not (Test-Path ".venv")) {
    Write-Host "❌ ERROR: Virtual environment not found" -ForegroundColor Red
    Write-Host "Please run .\setup.ps1 first to create the environment" -ForegroundColor Yellow
    exit 1
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Cyan
& ".venv\Scripts\Activate.ps1"
Write-Host "✓ Virtual environment activated" -ForegroundColor Green
Write-Host ""

# Check if pytest is installed
try {
    python -c "import pytest" 2>$null
    if ($LASTEXITCODE -ne 0) { throw }
} catch {
    Write-Host "❌ ERROR: pytest is not installed" -ForegroundColor Red
    Write-Host "Installing pytest..." -ForegroundColor Yellow
    pip install pytest
    Write-Host "✓ pytest installed" -ForegroundColor Green
    Write-Host ""
}

# Check if test file exists
if (-not (Test-Path "test_app.py")) {
    Write-Host "❌ ERROR: test_app.py not found" -ForegroundColor Red
    Write-Host "Please ensure test_app.py exists in the current directory" -ForegroundColor Yellow
    exit 1
}

# Clean up any existing test database
if (Test-Path "test_app.db") {
    Write-Host "Cleaning up previous test database..." -ForegroundColor Cyan
    Remove-Item "test_app.db" -Force
    Write-Host "✓ Test database cleaned" -ForegroundColor Green
    Write-Host ""
}

# Display menu
Write-Host "Select test mode:" -ForegroundColor Cyan
Write-Host "  1. Run all tests (verbose)" -ForegroundColor White
Write-Host "  2. Run all tests (quiet - summary only)" -ForegroundColor White
Write-Host "  3. Run tests with coverage report" -ForegroundColor White
Write-Host "  4. Run specific test class" -ForegroundColor White
Write-Host "  5. Run failed tests only" -ForegroundColor White
Write-Host ""
$choice = Read-Host "Enter your choice (1-5) [default: 1]"
if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "1" }
Write-Host ""

switch ($choice) {
    "1" {
        Write-Host "Running all tests with verbose output..." -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        pytest test_app.py -v --tb=short
        $testExitCode = $LASTEXITCODE
    }
    "2" {
        Write-Host "Running all tests (quiet mode)..." -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        pytest test_app.py -q
        $testExitCode = $LASTEXITCODE
    }
    "3" {
        Write-Host "Running tests with coverage report..." -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        # Install coverage if not present
        try {
            python -c "import pytest_cov" 2>$null
            if ($LASTEXITCODE -ne 0) { throw }
        } catch {
            Write-Host "Installing pytest-cov..." -ForegroundColor Yellow
            pip install pytest-cov
        }
        pytest test_app.py -v --cov=. --cov-report=term-missing --cov-report=html
        $testExitCode = $LASTEXITCODE
        Write-Host ""
        Write-Host "✓ HTML coverage report generated in htmlcov\index.html" -ForegroundColor Green
    }
    "4" {
        Write-Host "Available test classes:" -ForegroundColor Cyan
        Write-Host "  - TestRoutes" -ForegroundColor White
        Write-Host "  - TestRegistrationForm" -ForegroundColor White
        Write-Host "  - TestLoginForm" -ForegroundColor White
        Write-Host "  - TestAPIEndpoints" -ForegroundColor White
        Write-Host "  - TestConfiguration" -ForegroundColor White
        Write-Host "  - TestPasswordRequirements" -ForegroundColor White
        Write-Host "  - TestUserModel" -ForegroundColor White
        Write-Host "  - TestApplicationBehavior" -ForegroundColor White
        Write-Host ""
        $testClass = Read-Host "Enter test class name"
        Write-Host ""
        Write-Host "Running tests for $testClass..." -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        pytest "test_app.py::$testClass" -v --tb=short
        $testExitCode = $LASTEXITCODE
    }
    "5" {
        Write-Host "Running only failed tests from last run..." -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        pytest test_app.py --lf -v --tb=short
        $testExitCode = $LASTEXITCODE
    }
    default {
        Write-Host "❌ Invalid choice" -ForegroundColor Red
        exit 1
    }
}

# Check test results
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

if ($testExitCode -eq 0) {
    Write-Host "✓ All tests passed successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Test Summary:" -ForegroundColor Cyan
    Write-Host "  - Test file: test_app.py" -ForegroundColor White
    Write-Host "  - Status: PASSED ✓" -ForegroundColor Green
    Write-Host "  - Exit code: 0" -ForegroundColor White
    Write-Host ""
    Write-Host "The application is working correctly according to" -ForegroundColor White
    Write-Host "the specifications in corrected_readme.md" -ForegroundColor White
} else {
    Write-Host "❌ Some tests failed" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Test Summary:" -ForegroundColor Cyan
    Write-Host "  - Test file: test_app.py" -ForegroundColor White
    Write-Host "  - Status: FAILED ✗" -ForegroundColor Red
    Write-Host "  - Exit code: $testExitCode" -ForegroundColor White
    Write-Host ""
    Write-Host "Please review the test output above for details" -ForegroundColor Yellow
    Write-Host "Check defects.txt for known issues" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "For more information:" -ForegroundColor Cyan
Write-Host "  - See corrected_readme.md for usage" -ForegroundColor White
Write-Host "  - See defects.txt for known issues" -ForegroundColor White
Write-Host "  - Run 'pytest test_app.py --help' for more options" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan

exit $testExitCode
