###############################################################################
# Flask User Management - Environment Setup Script (PowerShell)
# This script sets up the Python virtual environment and installs dependencies
###############################################################################

# Enable strict mode
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Flask User Management - Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Found: $pythonVersion" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "❌ ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python 3.7 or higher from https://www.python.org/" -ForegroundColor Yellow
    exit 1
}

# Remove existing virtual environment if it exists
if (Test-Path ".venv") {
    Write-Host "⚠ Existing virtual environment found at .venv" -ForegroundColor Yellow
    $response = Read-Host "Do you want to remove it and create a fresh environment? (y/n)"
    
    if ($response -match '^[Yy]$') {
        Write-Host "Removing existing .venv directory..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force .venv
        Write-Host "✓ Removed existing virtual environment" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host "⚠ Keeping existing virtual environment" -ForegroundColor Yellow
        Write-Host ""
    }
}

# Create virtual environment
if (-not (Test-Path ".venv")) {
    Write-Host "Creating Python virtual environment..." -ForegroundColor Cyan
    python -m venv .venv
    Write-Host "✓ Virtual environment created at .venv" -ForegroundColor Green
    Write-Host ""
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Cyan
& ".venv\Scripts\Activate.ps1"
Write-Host "✓ Virtual environment activated" -ForegroundColor Green
Write-Host ""

# Upgrade pip
Write-Host "Upgrading pip to latest version..." -ForegroundColor Cyan
python -m pip install --upgrade pip --quiet
$pipVersion = python -m pip --version
Write-Host "✓ $pipVersion" -ForegroundColor Green
Write-Host ""

# Install requirements
if (-not (Test-Path "requirements.txt")) {
    Write-Host "❌ ERROR: requirements.txt not found in current directory" -ForegroundColor Red
    Write-Host "Please ensure you are running this script from the project root" -ForegroundColor Yellow
    exit 1
}

Write-Host "Installing dependencies from requirements.txt..." -ForegroundColor Cyan
pip install -r requirements.txt
Write-Host "✓ All dependencies installed successfully" -ForegroundColor Green
Write-Host ""

# Verify key packages
Write-Host "Verifying installed packages..." -ForegroundColor Cyan
try {
    $flaskVersion = python -c "import flask; print(flask.__version__)" 2>$null
    if (-not $flaskVersion) { $flaskVersion = "NOT INSTALLED" }
} catch {
    $flaskVersion = "NOT INSTALLED"
}

try {
    $flaskLoginVersion = python -c "import flask_login; print(flask_login.__version__)" 2>$null
    if (-not $flaskLoginVersion) { $flaskLoginVersion = "NOT INSTALLED" }
} catch {
    $flaskLoginVersion = "NOT INSTALLED"
}

try {
    $pytestVersion = python -c "import pytest; print(pytest.__version__)" 2>$null
    if (-not $pytestVersion) { $pytestVersion = "NOT INSTALLED" }
} catch {
    $pytestVersion = "NOT INSTALLED"
}

Write-Host "  - Flask: $flaskVersion" -ForegroundColor White
Write-Host "  - Flask-Login: $flaskLoginVersion" -ForegroundColor White
Write-Host "  - pytest: $pytestVersion" -ForegroundColor White
Write-Host ""

# Check for required application files
Write-Host "Checking for required application files..." -ForegroundColor Cyan
$missingFiles = 0

$requiredFiles = @("app.py", "auth.py", "models.py", "test_app.py")
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file (MISSING)" -ForegroundColor Red
        $missingFiles++
    }
}

if (Test-Path "templates") {
    Write-Host "  ✓ templates/ directory" -ForegroundColor Green
} else {
    Write-Host "  ❌ templates/ directory (MISSING)" -ForegroundColor Red
    $missingFiles++
}

Write-Host ""

if ($missingFiles -gt 0) {
    Write-Host "⚠ WARNING: $missingFiles required file(s) missing" -ForegroundColor Yellow
    Write-Host "The application may not function correctly" -ForegroundColor Yellow
    Write-Host ""
}

# Success message
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ Setup completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Activate the virtual environment:" -ForegroundColor White
Write-Host "     .venv\Scripts\Activate.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. Run the application:" -ForegroundColor White
Write-Host "     python app.py" -ForegroundColor Yellow
Write-Host ""
Write-Host "  3. Open your browser and navigate to:" -ForegroundColor White
Write-Host "     http://localhost:5000" -ForegroundColor Yellow
Write-Host ""
Write-Host "  4. Run tests:" -ForegroundColor White
Write-Host "     pytest test_app.py -v" -ForegroundColor Yellow
Write-Host "     or use: .\run_tests.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "For more information, see corrected_readme.md" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
