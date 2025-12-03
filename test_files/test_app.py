import os
import tempfile
import pytest


@pytest.fixture
def client(tmp_path, monkeypatch):
    # Import the app and configure a temporary test database
    from app import app as flask_app

    flask_app.config['TESTING'] = True
    # Disable CSRF for tests
    flask_app.config['WTF_CSRF_ENABLED'] = False

    db_file = tmp_path / "test.db"
    flask_app.config['DATABASE'] = str(db_file)

    # Initialize the database for tests
    from models import init_db
    init_db(flask_app)

    with flask_app.test_client() as client:
        yield client


def test_index_redirects_to_login(client):
    rv = client.get('/')
    assert rv.status_code in (301, 302)
    assert '/login' in rv.location


def test_register_and_dashboard_flow(client):
    # Register a new user
    data = {
        'username': 'alice',
        'email': 'alice@example.com',
        'password': 'supersecret',
        'submit': 'Register'
    }
    rv = client.post('/register', data=data, follow_redirects=True)
    assert rv.status_code == 200
    assert b'Hello, <strong>alice</strong>!' in rv.data

    # Log out
    rv = client.get('/logout', follow_redirects=True)
    assert rv.status_code == 200

    # Log in with the same user
    rv = client.post('/login', data={'username': 'alice', 'password': 'supersecret', 'submit': 'Login'}, follow_redirects=True)
    assert rv.status_code == 200
    assert b'Hello, <strong>alice</strong>!' in rv.data


def test_register_short_password_fails(client):
    rv = client.post('/register', data={
        'username': 'bob',
        'email': 'bob@example.com',
        'password': 'abc',
        'submit': 'Register'
    }, follow_redirects=True)
    # validation should fail due to length < 6 and the registration page should be shown again
    assert rv.status_code == 200
    assert b'User Registration' in rv.data


def test_register_missing_email_fails(client):
    rv = client.post('/register', data={
        'username': 'carol',
        'email': '',
        'password': 'password123',
        'submit': 'Register'
    }, follow_redirects=True)
    assert rv.status_code == 200
    assert b'This field is required' in rv.data or b'This field is required.' in rv.data


def test_api_endpoints_absent(client):
    # README claims /api/register exists; it should not
    rv = client.post('/api/register', json={'user': 'x', 'pass': 'y', 'mail': 'e@x.com'})
    assert rv.status_code == 404


def test_database_path_default():
    # The README claims the database is data/database.sqlite3, but the code defines a different default.
    import pathlib
    p = pathlib.Path(__file__).resolve().parents[1] / 'app.py'
    txt = p.read_text(encoding='utf8')
    assert "app.config['DATABASE'] = 'app.db'" in txt
