# Flask User Management Application - CORRECTED

This is a corrected and fully functional Flask-based login/registration application.

## Quick Start

### Prerequisites
- Python 3.8 or higher
- Git (optional)

### From Scratch Setup (Bash - Linux/macOS)

```bash
# Clone or download the project (if from git)
git clone <repository-url>
cd <project-directory>

# Create a Python virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies from requirements.txt
pip install --upgrade pip
pip install -r requirements.txt
```

### From Scratch Setup (PowerShell - Windows)

```powershell
# Navigate to project directory
cd <project-directory>

# Create a Python virtual environment
python -m venv .venv
.venv\Scripts\activate

# Install dependencies from requirements.txt
python -m pip install --upgrade pip
pip install -r requirements.txt
```

## Running the Application

### Option 1: Using Flask CLI (Recommended)
```bash
# Linux/macOS
export FLASK_APP=app.py
export FLASK_ENV=development
flask run --host=0.0.0.0 --port=5000

# Windows PowerShell
$env:FLASK_APP = "app.py"
$env:FLASK_ENV = "development"
flask run --host=0.0.0.0 --port=5000
```

### Option 2: Direct Python Execution
```bash
# Linux/macOS/Windows
python app.py
# Runs on http://localhost:5000 by default with debug=True
```

**Note:** The Quick Start command from the original README (`python app.py --host=0.0.0.0 --port=8080`) is incorrect and will fail. The app.run() method does not accept command-line flags.

Open your browser and navigate to `http://localhost:5000`.

## Tutorial: Register and Login

### User Registration

1. Navigate to `/register` in your browser
2. Fill in the registration form with:
   - **Username**: 3-32 characters
   - **Email**: Valid email address
   - **Password**: Minimum 6 characters
3. Click "Register" button
4. You will be automatically logged in and redirected to the dashboard

### User Login

1. Navigate to `/login` in your browser
2. Enter your credentials:
   - **Username**: Your registered username
   - **Password**: Your password (minimum 6 characters)
3. Click "Login" button
4. You will be redirected to the dashboard

### Dashboard

- After successful login, you will be redirected to `/dashboard`
- This page displays your username and basic user information
- Click "Logout" to end your session and return to the login page

## Application Routes

- `GET /` - Redirects to login (if not authenticated) or dashboard (if authenticated)
- `GET/POST /login` - User login form and handler
- `GET/POST /register` - User registration form and handler
- `GET /logout` - Logout endpoint (login required)
- `GET /dashboard` - Dashboard page (login required)

## Configuration

### Environment Variables (Optional)

While the current implementation uses a hardcoded secret key, it's recommended to use environment variables in production:

```bash
# Linux/macOS
export FLASK_SECRET_KEY="your-very-secret-key-here"
export FLASK_DATABASE="app.db"

# Windows PowerShell
$env:FLASK_SECRET_KEY = "your-very-secret-key-here"
$env:FLASK_DATABASE = "app.db"
```

**Note:** To use these environment variables, you need to modify `app.py` line 8:
```python
app.config['SECRET_KEY'] = os.environ.get('FLASK_SECRET_KEY', 'replace-with-a-strong-secret-key')
```

### Database Configuration

- **Database Type**: SQLite3
- **Database File**: `app.db` (created in the project root directory)
- **Location**: Configured via `app.config['DATABASE']` in `app.py`
- **Session Storage**: Flask-Login in-memory sessions (not Redis as incorrectly documented)

## Form Fields and Validation

### Registration Form (/register)
- **Username**: 
  - Required
  - Length: 3-32 characters
  - Must be unique
  
- **Email**: 
  - Required
  - Valid email format
  - Must be unique
  
- **Password**: 
  - Required
  - Minimum length: **6 characters** (NOT 3 as incorrectly documented)
  - Maximum length: 128 characters

### Login Form (/login)
- **Username**: 
  - Required
  - Length: 3-32 characters
  
- **Password**: 
  - Required
  - Minimum length: 6 characters
  - Maximum length: 128 characters

## API Endpoints (Not Currently Implemented)

**Note:** The original README documented JSON API endpoints (/api/register, /api/login) that do not exist in the current implementation. The application currently uses HTML forms only. JSON API support would need to be added as a future enhancement.

## Project Structure

```
.
├── app.py                 # Main Flask application
├── auth.py               # Authentication blueprints and forms
├── models.py             # User model and database functions
├── requirements.txt      # Python dependencies
├── templates/            # HTML templates
│   ├── base.html        # Base template with navbar
│   ├── login.html       # Login form template
│   ├── register.html    # Registration form template
│   └── dashboard.html   # Dashboard template (protected)
└── .venv/               # Virtual environment (created during setup)
```

## Testing

Run the test suite using pytest:

```bash
# Linux/macOS
source .venv/bin/activate
pytest -v

# Windows PowerShell
.venv\Scripts\activate
pytest -v
```

Test files are located in the `tests/` directory. Tests cover:
- User registration validation
- User login authentication
- Password verification
- Database operations
- Form validation

## Dependencies

See `requirements.txt` for a complete list. Key dependencies:

- **Flask 3.0.0** - Web framework
- **Flask-Login 0.6.3** - Session management and user authentication
- **Flask-WTF 1.2.1** - CSRF protection for forms
- **WTForms 3.1.2** - Form validation and rendering
- **Werkzeug 3.0.1** - WSGI utilities and password hashing
- **email_validator 2.2.0** - Email validation
- **pytest** - Testing framework

## Security Notes

1. **CSRF Protection**: All forms are protected by Flask-WTF CSRF tokens
2. **Password Hashing**: Passwords are hashed using Werkzeug's security functions
3. **SQL Injection**: All database queries use parameterized queries
4. **Session Management**: Flask-Login handles secure session management
5. **Email Validation**: Real email format validation is enforced

## Common Issues and Fixes

### Issue: `ModuleNotFoundError: No module named 'flask'`
**Fix**: Make sure you've activated the virtual environment and run `pip install -r requirements.txt`

### Issue: `RuntimeError: The session is unavailable because no secret key was set`
**Fix**: This should not occur - the app has a default SECRET_KEY. If it does, check that app.py is in the root directory.

### Issue: Email validation errors when registering
**Fix**: Make sure `email_validator` is installed: `pip install email_validator`

### Issue: "Username already taken" or "Email already registered" errors
**Fix**: This is expected behavior - use a unique username and email for each registration

### Issue: Database locked errors
**Fix**: Make sure the app is not running from multiple terminals. Stop the app and delete `app.db`, then restart.

## Original Documentation Issues Found

The following issues were identified in the original README and have been corrected:

1. ✗ Incorrect command-line arguments (`--host` and `--port`) - FIXED
2. ✗ Non-existent `/signup` endpoint (should be `/register`) - FIXED
3. ✗ Non-existent `/signin` endpoint (should be `/login`) - FIXED
4. ✗ Non-existent `/profile` endpoint (should be `/dashboard`) - FIXED
5. ✗ Non-existent JSON API endpoints (`/api/register`, `/api/login`) - DOCUMENTED
6. ✗ Incorrect database path (`data/database.sqlite3` vs actual `app.db`) - FIXED
7. ✗ Incorrect Redis session storage claim (not implemented) - FIXED
8. ✗ Incorrect password minimum length (3 vs actual 6) - FIXED
9. ✗ Missing `confirm_password` field in registration form - FIXED
10. ✗ Non-existent environment variable usage (`FLASK_SECRET`) - FIXED
11. ✗ Incomplete package installation instructions - FIXED

## Next Steps

To extend this application, consider:

1. **Implement JSON API endpoints** for mobile/SPA clients
2. **Add email verification** during registration
3. **Add password reset functionality** via email
4. **Implement user profile editing**
5. **Add role-based access control** (admin, moderator, user)
6. **Deploy to production** with proper WSGI server (Gunicorn, uWSGI)
7. **Switch to production database** (PostgreSQL, MySQL)
8. **Implement Redis** for session storage in production

## License

[Specify your license here]

## Support

For issues or questions, please refer to the official Flask documentation:
- https://flask.palletsprojects.com/
- https://flask-login.readthedocs.io/
- https://wtforms.readthedocs.io/
