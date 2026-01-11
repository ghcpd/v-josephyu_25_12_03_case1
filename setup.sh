#!/bin/bash

###############################################################################
# Flask User Management - Environment Setup Script (Bash)
# This script sets up the Python virtual environment and installs dependencies
###############################################################################

set -e  # Exit on any error

echo "========================================"
echo "Flask User Management - Setup Script"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ ERROR: Python 3 is not installed or not in PATH"
    echo "Please install Python 3.7 or higher from https://www.python.org/"
    exit 1
fi

# Display Python version
PYTHON_VERSION=$(python3 --version)
echo "✓ Found: $PYTHON_VERSION"
echo ""

# Remove existing virtual environment if it exists
if [ -d ".venv" ]; then
    echo "⚠ Existing virtual environment found at .venv"
    read -p "Do you want to remove it and create a fresh environment? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Removing existing .venv directory..."
        rm -rf .venv
        echo "✓ Removed existing virtual environment"
        echo ""
    else
        echo "⚠ Keeping existing virtual environment"
        echo ""
    fi
fi

# Create virtual environment
if [ ! -d ".venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
    echo "✓ Virtual environment created at .venv"
    echo ""
fi

# Activate virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate
echo "✓ Virtual environment activated"
echo ""

# Upgrade pip
echo "Upgrading pip to latest version..."
pip install --upgrade pip --quiet
PIP_VERSION=$(pip --version)
echo "✓ $PIP_VERSION"
echo ""

# Install requirements
if [ ! -f "requirements.txt" ]; then
    echo "❌ ERROR: requirements.txt not found in current directory"
    echo "Please ensure you are running this script from the project root"
    exit 1
fi

echo "Installing dependencies from requirements.txt..."
pip install -r requirements.txt
echo "✓ All dependencies installed successfully"
echo ""

# Verify key packages
echo "Verifying installed packages..."
FLASK_VERSION=$(python3 -c "import flask; print(flask.__version__)" 2>/dev/null || echo "NOT INSTALLED")
FLASK_LOGIN_VERSION=$(python3 -c "import flask_login; print(flask_login.__version__)" 2>/dev/null || echo "NOT INSTALLED")
PYTEST_VERSION=$(python3 -c "import pytest; print(pytest.__version__)" 2>/dev/null || echo "NOT INSTALLED")

echo "  - Flask: $FLASK_VERSION"
echo "  - Flask-Login: $FLASK_LOGIN_VERSION"
echo "  - pytest: $PYTEST_VERSION"
echo ""

# Check for required application files
echo "Checking for required application files..."
MISSING_FILES=0

for file in "app.py" "auth.py" "models.py" "test_app.py"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ❌ $file (MISSING)"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

if [ ! -d "templates" ]; then
    echo "  ❌ templates/ directory (MISSING)"
    MISSING_FILES=$((MISSING_FILES + 1))
else
    echo "  ✓ templates/ directory"
fi

echo ""

if [ $MISSING_FILES -gt 0 ]; then
    echo "⚠ WARNING: $MISSING_FILES required file(s) missing"
    echo "The application may not function correctly"
    echo ""
fi

# Success message
echo "========================================"
echo "✓ Setup completed successfully!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Activate the virtual environment:"
echo "     source .venv/bin/activate"
echo ""
echo "  2. Run the application:"
echo "     python app.py"
echo ""
echo "  3. Open your browser and navigate to:"
echo "     http://localhost:5000"
echo ""
echo "  4. Run tests:"
echo "     pytest test_app.py -v"
echo "     or use: ./run_tests.sh"
echo ""
echo "For more information, see corrected_readme.md"
echo "========================================"
