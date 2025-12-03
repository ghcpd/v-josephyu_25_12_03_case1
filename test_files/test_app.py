import pytest
from app import app
from models import init_db

def make_client(tmp_path):
    app.config['TESTING'] = True
    app.config['WTF_CSRF_ENABLED'] = False
    app.config['DATABASE'] = str(tmp_path / 'test.db')
    init_db(app)
    return app.test_client()

@pytest.fixture
def client(tmp_path):
    with make_client(tmp_path) as client:
        yield client


def test_dashboard_requires_login(client):
    resp = client.get('/dashboard', follow_redirects=False)
    assert resp.status_code == 302
    assert '/login' in resp.headers['Location']


def test_register_and_login_flow(client):
    # Register
    resp = client.post('/register', data={
        'username': 'alice',
        'email': 'alice@example.com',
        'password': 'secret123'
    }, follow_redirects=True)
    assert resp.status_code == 200
    assert b'Hello, <strong>alice</strong>' in resp.data

    # Logout
    resp = client.get('/logout', follow_redirects=False)
    assert resp.status_code == 302

    # Login
    resp = client.post('/login', data={
        'username': 'alice',
        'password': 'secret123'
    }, follow_redirects=True)
    assert resp.status_code == 200
    assert b'Hello, <strong>alice</strong>' in resp.data


def test_duplicate_username(client):
    client.post('/register', data={
        'username': 'bob',
        'email': 'bob@example.com',
        'password': 'secret123'
    })
    resp = client.post('/register', data={
        'username': 'bob',
        'email': 'bob2@example.com',
        'password': 'secret123'
    }, follow_redirects=True)

    assert b'Username is already taken' in resp.data


def test_password_length_validation(client):
    resp = client.post('/register', data={
        'username': 'charlie',
        'email': 'charlie@example.com',
        'password': 'abc'
    }, follow_redirects=True)
    assert resp.status_code == 200
    assert b'Field must be between' in resp.data


def test_email_required(client):
    resp = client.post('/register', data={
        'username': 'delta',
        'email': '',
        'password': 'secret123'
    }, follow_redirects=True)
    assert resp.status_code == 200
    assert b'This field is required' in resp.data


def test_login_invalid_credentials(client):
    resp = client.post('/login', data={
        'username': 'ghost',
        'password': 'wrongpass'
    }, follow_redirects=True)
    assert resp.status_code == 200
    assert b'Invalid username or password' in resp.data
