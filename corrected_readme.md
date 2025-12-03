# Flask User Management Tutorial (Corrected)

This README provides accurate, tested documentation for building a login/registration application with Flask.

## Prerequisites

- Python 3.7 or higher
- pip (Python package manager)

## From Scratch Setup

### Linux/macOS

```bash
# Create a Python virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Upgrade pip (recommended)
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

### Windows (PowerShell)

```powershell
# Create a Python virtual environment
python -m venv .venv

# Activate the virtual environment
.venv\Scripts\activate

# Upgrade pip (recommended)
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

### Windows (Command Prompt)

```cmd
# Create a Python virtual environment
python -m venv .venv

# Activate the virtual environment
.venv\Scripts\activate.bat

# Upgrade pip (recommended)
pip install --upgrade pip

# Install dependencies
pip install -r requirements.txt
```

## Quick Start

```bash
python app.py
```

The application will start on `http://127.0.0.1:5000` by default.

Open your web browser and navigate to:
```
http://localhost:5000
```

You will be redirected to the login page.

## Project Structure

```
.
├── app.py              # Main application file
├── auth.py             # Authentication blueprint (login, register, logout)
├── models.py           # User model and database operations
├── requirements.txt    # Python dependencies
├── test_app.py        # Comprehensive test suite
├── templates/          # HTML templates
│   ├── base.html      # Base template with navigation
│   ├── login.html     # Login form
│   ├── register.html  # Registration form
│   └── dashboard.html # User dashboard (after login)
└── app.db             # SQLite database (created automatically)
```

## Tutorial: Register and Login

### Step 1: Register a New User

1. Navigate to the registration page:
   ```
   http://localhost:5000/register
   ```

2. Fill in the registration form with the following **required** fields:
   - **Username**: 3-32 characters
   - **Email**: Valid email address (required, not optional)
   - **Password**: 6-128 characters (minimum 6 characters)

3. Click "Register"

4. Upon successful registration, you will be automatically logged in and redirected to the dashboard

### Step 2: Login

1. If you've logged out, navigate to the login page:
   ```
   http://localhost:5000/login
   ```

2. Enter your credentials:
   - **Username**: Your registered username
   - **Password**: Your password

3. Click "Login"

4. Upon successful login, you will be redirected to the dashboard

### Step 3: View Dashboard

Once logged in, you can access your dashboard at:
```
http://localhost:5000/dashboard
```

The dashboard displays your username and provides a logout button.

### Step 4: Logout

Click the "Log Out" button on the dashboard, or navigate to:
```
http://localhost:5000/logout
```

You will be redirected to the login page.

## Available Routes

| Route | Method | Description | Authentication Required |
|-------|--------|-------------|------------------------|
| `/` | GET | Home page (redirects to login or dashboard) | No |
| `/login` | GET, POST | Login form and authentication | No |
| `/register` | GET, POST | Registration form and user creation | No |
| `/dashboard` | GET | User dashboard with profile information | Yes |
| `/logout` | GET | Logout and session cleanup | Yes |

## Configuration

### Secret Key

The application uses a hardcoded secret key for CSRF protection and session management. For production use, you should set a strong secret key:

**Option 1: Environment Variable (Recommended)**
```python
# In app.py, change:
app.config['SECRET_KEY'] = os.environ.get('FLASK_SECRET', 'replace-with-a-strong-secret-key')
```

Then set the environment variable:
```bash
# Linux/macOS
export FLASK_SECRET="your-very-strong-secret-key-here"

# Windows PowerShell
$env:FLASK_SECRET = "your-very-strong-secret-key-here"

# Windows Command Prompt
set FLASK_SECRET=your-very-strong-secret-key-here
```

**Option 2: Direct Configuration**
```python
# In app.py:
app.config['SECRET_KEY'] = 'your-very-strong-secret-key-here'
```

### Database

- **Location**: `app.db` (SQLite database in the project root directory)
- **Automatically created**: The database and tables are created automatically when you first run the application
- **Schema**: Single `users` table with columns: `id`, `username`, `password_hash`, `email`

To reset the database:
```bash
# Delete the database file
rm app.db  # Linux/macOS
del app.db  # Windows

# Restart the application - a fresh database will be created
python app.py
```

### Session Storage

Sessions are stored in client-side **encrypted cookies** (Flask default). For production applications handling sensitive data, consider using server-side session storage with Redis or memcached.

## Validation Rules

### Username
- **Required**: Yes
- **Minimum length**: 3 characters
- **Maximum length**: 32 characters
- **Must be unique**: No two users can have the same username

### Email
- **Required**: Yes (not optional)
- **Format**: Must be a valid email address
- **Maximum length**: 255 characters
- **Must be unique**: No two users can have the same email

### Password
- **Required**: Yes
- **Minimum length**: 6 characters
- **Maximum length**: 128 characters
- **Storage**: Passwords are hashed using Werkzeug's security utilities (PBKDF2)

## Running in Different Modes

### Development Mode (Default)

```bash
python app.py
```

This runs with debug mode enabled, which provides:
- Automatic reloading when code changes
- Detailed error pages
- Interactive debugger

**Warning**: Never use debug mode in production!

### Custom Host and Port

To run on a different host or port, modify `app.py`:

```python
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
```

Then access the application at `http://localhost:8080`

### Production Mode

For production deployment, use a WSGI server like Gunicorn or uWSGI:

```bash
# Install Gunicorn
pip install gunicorn

# Run with Gunicorn
gunicorn -w 4 -b 0.0.0.0:8000 app:app
```

## Testing

### Running the Test Suite

The project includes a comprehensive test suite with pytest.

```bash
# Run all tests with verbose output
pytest test_app.py -v

# Run tests with coverage report
pytest test_app.py --cov=. --cov-report=html

# Run specific test class
pytest test_app.py::TestRoutes -v

# Run a specific test
pytest test_app.py::TestRoutes::test_login_route_exists -v
```

### Test Coverage

The test suite includes:
- **Route Tests**: Verify all routes are accessible
- **Form Validation Tests**: Test registration and login forms
- **Authentication Tests**: Test login, logout, and session management
- **User Model Tests**: Test user creation, password hashing, and queries
- **Security Tests**: Verify authentication requirements

**Current Test Results**: 25 tests, all passing ✓

### Automated Testing Scripts

#### Linux/macOS
```bash
# Make script executable
chmod +x run_tests.sh

# Run tests
./run_tests.sh
```

#### Windows PowerShell
```powershell
.\run_tests.ps1
```

## Troubleshooting

### "No module named 'flask'"
**Solution**: Make sure you've activated the virtual environment and installed dependencies.
```bash
source .venv/bin/activate  # Linux/macOS
.venv\Scripts\activate     # Windows
pip install -r requirements.txt
```

### "Address already in use"
**Solution**: Port 5000 is already in use. Either:
1. Stop the other process using port 5000
2. Run on a different port (modify `app.py`)

### "Invalid username or password"
**Solution**: 
- Ensure you've registered the user first
- Check that username and password match exactly (case-sensitive)
- Verify password meets minimum 6-character requirement

### Database locked errors
**Solution**: Close any other applications or processes accessing `app.db`

### CSRF token missing or invalid
**Solution**: 
- Ensure you have a proper SECRET_KEY configured
- Make sure cookies are enabled in your browser
- Clear browser cache and cookies, then try again

## Security Best Practices

1. **Secret Key**: Use a strong, random secret key in production
2. **HTTPS**: Always use HTTPS in production to protect credentials in transit
3. **Password Policy**: Consider enforcing stronger password requirements
4. **Rate Limiting**: Implement rate limiting to prevent brute force attacks
5. **Session Timeout**: Configure appropriate session timeouts
6. **Input Sanitization**: The application uses WTForms for automatic input validation

## Dependencies

All required packages are listed in `requirements.txt`:

- **Flask** (3.0.0): Web framework
- **Flask-Login** (0.6.3): User session management
- **Flask-WTF** (1.2.1): Form handling and CSRF protection
- **WTForms** (3.1.2): Form validation
- **Werkzeug** (3.0.1): Security utilities (password hashing)
- **email_validator** (2.2.0): Email validation
- **pytest** (latest): Testing framework

## License

This is a tutorial project for educational purposes.

## Support

For issues, bugs, or questions:
1. Check the test suite for examples: `test_app.py`
2. Review the defects report: `defects.txt`
3. Examine the code comments in `app.py`, `auth.py`, and `models.py`

## Version History

- **v2.0 (Corrected)**: Accurate documentation matching actual implementation
  - Fixed route documentation (/register, /login, /dashboard)
  - Corrected password requirements (6 characters minimum)
  - Clarified email is required, not optional
  - Updated database location (app.db)
  - Removed non-existent API endpoints
  - Added comprehensive testing instructions

- **v1.0 (Original)**: Initial documentation (contained multiple defects)
