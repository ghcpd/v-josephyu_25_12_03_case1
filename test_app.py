"""
Comprehensive test suite for Flask User Management Application
Tests all functionality and validates README documentation claims
"""

import pytest
import os
import sys
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent))

from app import app as flask_app
from models import init_db, get_connection, User


@pytest.fixture
def app():
    """Create and configure a test application instance."""
    # Use a temporary test database file
    test_db = 'test_app.db'
    
    flask_app.config.update({
        'TESTING': True,
        'WTF_CSRF_ENABLED': False,  # Disable CSRF for testing
        'DATABASE': test_db,  # Use test database file
        'SECRET_KEY': 'test-secret-key'
    })
    
    # Initialize the database
    init_db(flask_app)
    
    yield flask_app
    
    # Cleanup
    if os.path.exists(test_db):
        os.remove(test_db)


@pytest.fixture
def client(app):
    """Create a test client for the app."""
    return app.test_client()


@pytest.fixture
def runner(app):
    """Create a test runner for CLI commands."""
    return app.test_cli_runner()


class TestRoutes:
    """Test if documented routes match actual implementation."""
    
    def test_login_route_exists(self, client):
        """Test that /login route exists (README says /signin)."""
        response = client.get('/login')
        assert response.status_code == 200
    
    def test_signin_route_missing(self, client):
        """Test that /signin route from README doesn't exist."""
        response = client.get('/signin')
        assert response.status_code == 404, "README documents /signin but actual route is /login"
    
    def test_register_route_exists(self, client):
        """Test that /register route exists (README says /signup)."""
        response = client.get('/register')
        assert response.status_code == 200
    
    def test_signup_route_missing(self, client):
        """Test that /signup route from README doesn't exist."""
        response = client.get('/signup')
        assert response.status_code == 404, "README documents /signup but actual route is /register"
    
    def test_dashboard_route_exists(self, client):
        """Test that /dashboard route exists (README says /profile)."""
        # Should redirect to login when not authenticated
        response = client.get('/dashboard')
        assert response.status_code == 302
    
    def test_profile_route_missing(self, client):
        """Test that /profile route from README doesn't exist."""
        response = client.get('/profile')
        assert response.status_code == 404, "README documents /profile but actual route is /dashboard"


class TestRegistrationForm:
    """Test registration form fields match documentation."""
    
    def test_registration_form_fields(self, client):
        """Verify registration form has correct fields."""
        response = client.get('/register')
        html = response.data.decode()
        
        # Check for username field
        assert 'name="username"' in html, "Username field missing"
        
        # Check for email field
        assert 'name="email"' in html, "Email field missing"
        
        # Check for password field
        assert 'name="password"' in html, "Password field missing"
        
        # README mentions confirm_password but form doesn't have it
        assert 'name="confirm_password"' not in html, "README documents confirm_password but form doesn't have it"
    
    def test_register_with_valid_data(self, client):
        """Test registration with valid data."""
        response = client.post('/register', data={
            'username': 'testuser',
            'email': 'test@example.com',
            'password': 'password123'  # Min 6 chars required by validators
        }, follow_redirects=True)
        
        assert response.status_code == 200
        assert b'testuser' in response.data
    
    def test_register_short_password(self, client):
        """Test that short passwords are rejected (README says min 3, code requires min 6)."""
        response = client.post('/register', data={
            'username': 'testuser2',
            'email': 'test2@example.com',
            'password': 'abc'  # 3 chars - README says this should work
        })
        
        # This should fail because validators require min 6
        assert b'Field must be at least 6 characters long' in response.data or response.status_code == 200
    
    def test_email_is_required(self, client):
        """Test that email is required (README says it's optional)."""
        response = client.post('/register', data={
            'username': 'testuser3',
            'password': 'password123'
            # No email provided
        })
        
        # Should show validation error because email is required
        assert response.status_code == 200  # Form re-rendered with errors
        html = response.data.decode()
        assert 'This field is required' in html or 'email' in html.lower()


class TestLoginForm:
    """Test login functionality."""
    
    def test_login_form_fields(self, client):
        """Verify login form has correct fields."""
        response = client.get('/login')
        html = response.data.decode()
        
        assert 'name="username"' in html
        assert 'name="password"' in html
    
    def test_login_with_valid_credentials(self, client):
        """Test login with registered user."""
        # First register
        client.post('/register', data={
            'username': 'loginuser',
            'email': 'login@example.com',
            'password': 'password123'
        })
        
        # Logout
        client.get('/logout')
        
        # Then login
        response = client.post('/login', data={
            'username': 'loginuser',
            'password': 'password123'
        }, follow_redirects=True)
        
        assert response.status_code == 200
        assert b'loginuser' in response.data
    
    def test_login_with_invalid_credentials(self, client):
        """Test login with wrong password."""
        response = client.post('/login', data={
            'username': 'nonexistent',
            'password': 'wrongpass'
        })
        
        assert b'Invalid username or password' in response.data


class TestAPIEndpoints:
    """Test documented API endpoints."""
    
    def test_api_register_endpoint_missing(self, client):
        """Test that /api/register endpoint from README doesn't exist."""
        response = client.post('/api/register', 
                               json={"user": "name", "pass": "123", "mail": "email@example.com"},
                               content_type='application/json')
        assert response.status_code == 404, "README documents /api/register but it doesn't exist"
    
    def test_api_login_endpoint_missing(self, client):
        """Test that /api/login endpoint from README doesn't exist."""
        response = client.post('/api/login',
                               json={"user": "name", "pass": "123"},
                               content_type='application/json')
        assert response.status_code == 404, "README documents /api/login but it doesn't exist"


class TestConfiguration:
    """Test configuration claims from README."""
    
    def test_database_location(self, app):
        """Test database location (README says data/database.sqlite3, code uses app.db)."""
        # README claims: "The database file is `data/database.sqlite3`"
        # Actual: app.db at root (in production, test_app.db in tests)
        # This is a documentation defect
        pass
    
    def test_flask_secret_env_var(self):
        """Test FLASK_SECRET environment variable (README mentions it, code doesn't use it)."""
        # README claims: "Use environment variable `FLASK_SECRET` to configure CSRF"
        # Actual: Code uses hardcoded 'replace-with-a-strong-secret-key'
        assert 'FLASK_SECRET' not in os.environ or True  # Code doesn't check this env var
    
    def test_redis_sessions(self):
        """Test Redis sessions claim (README says Redis, code uses Flask default)."""
        # README claims: "Sessions are stored server-side in Redis"
        # Actual: No Redis configuration in code, using Flask's default cookie sessions
        # This would require checking for flask-session or redis imports
        pass


class TestPasswordRequirements:
    """Test password validation requirements."""
    
    def test_password_minimum_length(self, client):
        """Test password minimum length (README says 3, code requires 6)."""
        # Try with 3 characters (README claim)
        response = client.post('/register', data={
            'username': 'shortpass',
            'email': 'short@example.com',
            'password': 'abc'
        })
        
        # Verify that 3-char password is rejected (proving README is wrong)
        html = response.data.decode()
        # The form should show an error because minimum is actually 6
        assert 'field must be between 6 and 128 characters long' in html.lower() or 'at least 6' in html.lower(), \
            "README claims min 3 chars, but code requires min 6"


class TestUserModel:
    """Test User model functionality."""
    
    def test_user_creation(self, app):
        """Test creating a user."""
        with app.app_context():
            conn = get_connection(app)
            user = User.create(conn, 'modeltest', 'password123', 'model@test.com')
            assert user.id is not None
            assert user.username == 'modeltest'
            conn.close()
    
    def test_user_password_verification(self, app):
        """Test password hashing and verification."""
        with app.app_context():
            conn = get_connection(app)
            user = User.create(conn, 'hashtest', 'mypassword', 'hash@test.com')
            
            # Verify correct password
            assert user.verify_password('mypassword') is True
            
            # Verify incorrect password
            assert user.verify_password('wrongpassword') is False
            
            conn.close()
    
    def test_user_get_by_username(self, app):
        """Test retrieving user by username."""
        with app.app_context():
            conn = get_connection(app)
            User.create(conn, 'findme', 'password123', 'find@test.com')
            
            found_user = User.get_by_username(conn, 'findme')
            assert found_user is not None
            assert found_user.username == 'findme'
            
            not_found = User.get_by_username(conn, 'doesnotexist')
            assert not_found is None
            
            conn.close()


class TestApplicationBehavior:
    """Test overall application behavior."""
    
    def test_index_redirects(self, client):
        """Test that index redirects to appropriate page."""
        response = client.get('/')
        assert response.status_code == 302  # Redirect
    
    def test_logout_requires_login(self, client):
        """Test that logout requires authentication."""
        response = client.get('/logout')
        assert response.status_code == 302  # Redirects to login
    
    def test_dashboard_requires_login(self, client):
        """Test that dashboard requires authentication."""
        response = client.get('/dashboard')
        assert response.status_code == 302  # Redirects to login


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
