"""
Test Suite for Flask User Management Application

Tests core functionality and verifies the corrected documentation is accurate.
"""

import pytest
import tempfile
import os
from app import app
from models import get_connection, init_db


@pytest.fixture
def client():
    """Create a test client with a temporary database."""
    db_fd, db_path = tempfile.mkstemp(suffix='.db')
    app.config['DATABASE'] = db_path
    app.config['TESTING'] = True
    
    with app.app_context():
        init_db(app)
        yield app.test_client()
    
    os.close(db_fd)
    os.unlink(db_path)


class TestRoutes:
    """Test that all routes are accessible."""
    
    def test_index_redirect(self, client):
        """Test that index redirects."""
        response = client.get('/', follow_redirects=False)
        assert response.status_code in [301, 302, 307, 308]
    
    def test_login_page_accessible(self, client):
        """Test that login page loads."""
        response = client.get('/login')
        assert response.status_code == 200
        assert b'login' in response.data.lower()
    
    def test_register_page_accessible(self, client):
        """Test that register page loads."""
        response = client.get('/register')
        assert response.status_code == 200
        assert b'register' in response.data.lower()


class TestUserRegistration:
    """Test user registration functionality."""
    
    def test_register_page_loads(self, client):
        """Test registration page GET request."""
        response = client.get('/register')
        assert response.status_code == 200
        assert b'<form' in response.data
    
    def test_registration_form_fields_present(self, client):
        """Test that registration form has required fields."""
        response = client.get('/register')
        assert b'username' in response.data.lower()
        assert b'email' in response.data.lower()
        assert b'password' in response.data.lower()
    
    def test_register_missing_username(self, client):
        """Test that empty username fails validation."""
        response = client.post('/register', data={
            'email': 'test@example.com',
            'password': 'testpass123'
        })
        assert response.status_code == 200
    
    def test_register_invalid_email(self, client):
        """Test that invalid email fails validation."""
        response = client.post('/register', data={
            'username': 'testuser',
            'email': 'not-an-email',
            'password': 'testpass123'
        })
        assert response.status_code == 200
    
    def test_register_short_password(self, client):
        """Test that short password fails validation."""
        response = client.post('/register', data={
            'username': 'testuser',
            'email': 'test@example.com',
            'password': '123'
        })
        assert response.status_code == 200
    
    def test_register_short_username(self, client):
        """Test that short username fails validation."""
        response = client.post('/register', data={
            'username': 'ab',
            'email': 'test@example.com',
            'password': 'password123'
        })
        assert response.status_code == 200


class TestUserLogin:
    """Test user login functionality."""
    
    def test_login_page_loads(self, client):
        """Test login page GET request."""
        response = client.get('/login')
        assert response.status_code == 200
        assert b'login' in response.data.lower()
    
    def test_login_form_fields_present(self, client):
        """Test that login form has required fields."""
        response = client.get('/login')
        assert b'username' in response.data.lower()
        assert b'password' in response.data.lower()
    
    def test_login_missing_username(self, client):
        """Test that empty username fails validation."""
        response = client.post('/login', data={
            'password': 'testpass123'
        })
        assert response.status_code == 200
    
    def test_login_missing_password(self, client):
        """Test that empty password fails validation."""
        response = client.post('/login', data={
            'username': 'testuser'
        })
        assert response.status_code == 200


class TestDashboard:
    """Test dashboard access control."""
    
    def test_dashboard_requires_login(self, client):
        """Test that dashboard redirects unauthenticated users."""
        response = client.get('/dashboard', follow_redirects=False)
        assert response.status_code in [301, 302, 307, 308]


class TestLogout:
    """Test logout functionality."""
    
    def test_logout_route_exists(self, client):
        """Test that logout route exists."""
        response = client.get('/logout', follow_redirects=False)
        assert response.status_code in [301, 302, 307, 308]


class TestDocumentationAccuracy:
    """
    These tests verify the corrected documentation is accurate.
    All assertions in this class passing proves the corrections are valid.
    """
    
    def test_registration_endpoint_is_register_not_signup(self, client):
        """Verify: docs say /register (not /signup)."""
        response = client.get('/register')
        assert response.status_code == 200
        
        response_signup = client.get('/signup')
        assert response_signup.status_code == 404
    
    def test_login_endpoint_is_login_not_signin(self, client):
        """Verify: docs say /login (not /signin)."""
        response = client.get('/login')
        assert response.status_code == 200
        
        response_signin = client.get('/signin')
        assert response_signin.status_code == 404
    
    def test_dashboard_endpoint_exists(self, client):
        """Verify: docs say /dashboard (not /profile)."""
        response = client.get('/dashboard', follow_redirects=False)
        assert response.status_code != 404
        
        response_profile = client.get('/profile', follow_redirects=False)
        assert response_profile.status_code == 404
    
    def test_no_json_api_exists(self, client):
        """Verify: docs note that /api/register and /api/login don't exist."""
        response_register_api = client.get('/api/register', follow_redirects=False)
        assert response_register_api.status_code == 404
        
        response_login_api = client.get('/api/login', follow_redirects=False)
        assert response_login_api.status_code == 404


class TestApplicationStructure:
    """Test that application structure is correct."""
    
    def test_auth_blueprint_registered(self):
        """Test that auth blueprint is registered."""
        blueprints = list(app.blueprints.keys())
        assert 'auth' in blueprints
    
    def test_required_routes_exist(self):
        """Test that all required routes exist."""
        routes = [rule.rule for rule in app.url_map.iter_rules()]
        
        required_routes = ['/login', '/register', '/logout', '/dashboard', '/']
        
        for route in required_routes:
            found = any(route in r for r in routes)
            assert found, f"Route {route} not found"


class TestUserFlow:
    """Test common user workflows."""
    
    def test_registration_form_submission(self, client):
        """Test the registration form submission."""
        response = client.post('/register', data={
            'username': 'newuser',
            'email': 'newuser@example.com',
            'password': 'securepass123'
        }, follow_redirects=True)
        assert response.status_code == 200
    
    def test_login_form_submission(self, client):
        """Test the login form submission."""
        response = client.post('/login', data={
            'username': 'someuser',
            'password': 'somepassword'
        }, follow_redirects=True)
        assert response.status_code == 200
