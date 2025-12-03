#!/bin/bash
# Test runner script for Flask User Management Application (Linux/macOS)

set -e  # Exit on error

echo "========================================="
echo "Flask User Management - Test Runner"
echo "========================================="
echo ""

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo "Virtual environment not activated. Activating..."
    source .venv/bin/activate
    echo "✓ Virtual environment activated"
    echo ""
fi

# Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo "ERROR: pytest is not installed."
    echo "Install it with: pip install pytest"
    exit 1
fi

# Run tests
echo "Running tests..."
echo ""

pytest -v tests/test_app.py --tb=short

TEST_EXIT_CODE=$?

echo ""
echo "========================================="

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✓ All tests passed!" -ForegroundColor Green
else
    echo "✗ Some tests failed. Exit code: $TEST_EXIT_CODE"
fi

echo "========================================="
echo ""
echo "Test coverage report (optional):"
echo "  pytest --cov=. --cov-report=html tests/"
echo ""

exit $TEST_EXIT_CODE
