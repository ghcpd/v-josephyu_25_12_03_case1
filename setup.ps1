# Setup script for Flask User Management Application (Windows PowerShell)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Flask User Management - Setup Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
$pythonExe = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonExe) {
    Write-Host "ERROR: Python is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Please install Python 3.8 or higher from https://www.python.org/" -ForegroundColor Red
    exit 1
}

$pythonVersion = python --version 2>&1
Write-Host "✓ $pythonVersion" -ForegroundColor Green

# Create virtual environment
Write-Host ""
Write-Host "Creating virtual environment..."
if (Test-Path ".venv") {
    Write-Host "  .venv directory already exists. Skipping creation." -ForegroundColor Yellow
} else {
    python -m venv .venv
    Write-Host "  ✓ Virtual environment created" -ForegroundColor Green
}

# Activate virtual environment
Write-Host ""
Write-Host "Activating virtual environment..."
& ".venv\Scripts\Activate.ps1"
Write-Host "  ✓ Virtual environment activated" -ForegroundColor Green

# Upgrade pip
Write-Host ""
Write-Host "Upgrading pip..."
python -m pip install --upgrade pip --quiet
Write-Host "  ✓ pip upgraded" -ForegroundColor Green

# Install requirements
Write-Host ""
Write-Host "Installing requirements from requirements.txt..."
pip install -r requirements.txt --quiet
Write-Host "  ✓ All dependencies installed" -ForegroundColor Green

# Initialize database
Write-Host ""
Write-Host "Initializing database..."
python -c "
from app import app
from models import init_db
init_db(app)
print('  Database initialized')
"
Write-Host "  ✓ Database initialized" -ForegroundColor Green

# Summary
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "✓ Setup Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Activate the virtual environment:" -ForegroundColor White
Write-Host "   .venv\Scripts\Activate.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Run the application:" -ForegroundColor White
Write-Host "   flask run --host=0.0.0.0 --port=5000" -ForegroundColor Gray
Write-Host "   OR:" -ForegroundColor Gray
Write-Host "   python app.py" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Open your browser and navigate to:" -ForegroundColor White
Write-Host "   http://localhost:5000" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Run tests:" -ForegroundColor White
Write-Host "   pytest -v" -ForegroundColor Gray
Write-Host ""
