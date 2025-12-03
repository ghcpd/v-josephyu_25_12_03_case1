#!/bin/bash
# Setup script for Flask User Management Application (Linux/macOS)

set -e  # Exit on error

echo "========================================="
echo "Flask User Management - Setup Script"
echo "========================================="
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo "✓ Python version: $PYTHON_VERSION"

# Create virtual environment
echo ""
echo "Creating virtual environment..."
if [ -d ".venv" ]; then
    echo "  .venv directory already exists. Skipping creation."
else
    python3 -m venv .venv
    echo "  ✓ Virtual environment created"
fi

# Activate virtual environment
echo ""
echo "Activating virtual environment..."
source .venv/bin/activate
echo "  ✓ Virtual environment activated"

# Upgrade pip
echo ""
echo "Upgrading pip..."
python -m pip install --upgrade pip --quiet
echo "  ✓ pip upgraded"

# Install requirements
echo ""
echo "Installing requirements from requirements.txt..."
pip install -r requirements.txt --quiet
echo "  ✓ All dependencies installed"

# Initialize database
echo ""
echo "Initializing database..."
python -c "
from app import app
from models import init_db
init_db(app)
print('  ✓ Database initialized')
"

# Summary
echo ""
echo "========================================="
echo "✓ Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Activate the virtual environment:"
echo "   source .venv/bin/activate"
echo ""
echo "2. Run the application:"
echo "   flask run --host=0.0.0.0 --port=5000"
echo ""
echo "   OR:"
echo "   python app.py"
echo ""
echo "3. Open your browser and navigate to:"
echo "   http://localhost:5000"
echo ""
echo "4. Run tests:"
echo "   pytest -v"
echo ""
