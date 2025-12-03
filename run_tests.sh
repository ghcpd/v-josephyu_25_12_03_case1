#!/bin/bash

###############################################################################
# Flask User Management - Test Execution Script (Bash)
# This script runs the pytest test suite with various options
###############################################################################

set -e  # Exit on any error

echo "========================================"
echo "Flask User Management - Test Suite"
echo "========================================"
echo ""

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo "❌ ERROR: Virtual environment not found"
    echo "Please run ./setup.sh first to create the environment"
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate
echo "✓ Virtual environment activated"
echo ""

# Check if pytest is installed
if ! python3 -c "import pytest" &> /dev/null; then
    echo "❌ ERROR: pytest is not installed"
    echo "Installing pytest..."
    pip install pytest
    echo "✓ pytest installed"
    echo ""
fi

# Check if test file exists
if [ ! -f "test_app.py" ]; then
    echo "❌ ERROR: test_app.py not found"
    echo "Please ensure test_app.py exists in the current directory"
    exit 1
fi

# Clean up any existing test database
if [ -f "test_app.db" ]; then
    echo "Cleaning up previous test database..."
    rm test_app.db
    echo "✓ Test database cleaned"
    echo ""
fi

# Display menu
echo "Select test mode:"
echo "  1. Run all tests (verbose)"
echo "  2. Run all tests (quiet - summary only)"
echo "  3. Run tests with coverage report"
echo "  4. Run specific test class"
echo "  5. Run failed tests only"
echo ""
read -p "Enter your choice (1-5) [default: 1]: " choice
choice=${choice:-1}
echo ""

case $choice in
    1)
        echo "Running all tests with verbose output..."
        echo "========================================"
        pytest test_app.py -v --tb=short
        ;;
    2)
        echo "Running all tests (quiet mode)..."
        echo "========================================"
        pytest test_app.py -q
        ;;
    3)
        echo "Running tests with coverage report..."
        echo "========================================"
        # Install coverage if not present
        if ! python3 -c "import pytest_cov" &> /dev/null; then
            echo "Installing pytest-cov..."
            pip install pytest-cov
        fi
        pytest test_app.py -v --cov=. --cov-report=term-missing --cov-report=html
        echo ""
        echo "✓ HTML coverage report generated in htmlcov/index.html"
        ;;
    4)
        echo "Available test classes:"
        echo "  - TestRoutes"
        echo "  - TestRegistrationForm"
        echo "  - TestLoginForm"
        echo "  - TestAPIEndpoints"
        echo "  - TestConfiguration"
        echo "  - TestPasswordRequirements"
        echo "  - TestUserModel"
        echo "  - TestApplicationBehavior"
        echo ""
        read -p "Enter test class name: " testclass
        echo ""
        echo "Running tests for $testclass..."
        echo "========================================"
        pytest test_app.py::$testclass -v --tb=short
        ;;
    5)
        echo "Running only failed tests from last run..."
        echo "========================================"
        pytest test_app.py --lf -v --tb=short
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

# Check test results
TEST_EXIT_CODE=$?
echo ""
echo "========================================"

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✓ All tests passed successfully!"
    echo "========================================"
    echo ""
    echo "Test Summary:"
    echo "  - Test file: test_app.py"
    echo "  - Status: PASSED ✓"
    echo "  - Exit code: 0"
    echo ""
    echo "The application is working correctly according to"
    echo "the specifications in corrected_readme.md"
else
    echo "❌ Some tests failed"
    echo "========================================"
    echo ""
    echo "Test Summary:"
    echo "  - Test file: test_app.py"
    echo "  - Status: FAILED ✗"
    echo "  - Exit code: $TEST_EXIT_CODE"
    echo ""
    echo "Please review the test output above for details"
    echo "Check defects.txt for known issues"
fi

echo ""
echo "For more information:"
echo "  - See corrected_readme.md for usage"
echo "  - See defects.txt for known issues"
echo "  - Run 'pytest test_app.py --help' for more options"
echo "========================================"

exit $TEST_EXIT_CODE
