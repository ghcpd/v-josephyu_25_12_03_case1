import os
import tempfile
import pytest
from app import app as flask_app
from models import init_db, get_connection

@pytest.fixture
def client(tmp_path):
    # Use a temporary database file
    db_file = tmp_path / "test_app.db"
    flask_app.config['DATABASE'] = str(db_file)
    flask_app.config['WTF_CSRF_ENABLED'] = False
    init_db(flask_app)
    with flask_app.test_client() as c:
        yield c


def test_signup_route_missing(client):
    # README says signup route is /signup but code uses /register
    resp = client.get('/signup')
    assert resp.status_code == 404


def test_register_route_exists(client):
    resp = client.get('/register')
    assert resp.status_code == 200


def test_api_register_missing(client):
    # README documents /api/register but no such endpoint exists
    resp = client.post('/api/register', json={"user":"bob","pass":"123","mail":"b@example.com"})
    assert resp.status_code == 404


def test_password_min_length_mismatch(client):
    # README says min length 3 but form requires 6
    resp = client.post('/register', data={
        'username': 'testuser',
        'email': 't@example.com',
        'password': 'abc',
        'submit': 'Register'
    }, follow_redirects=True)
    # Should not create user because password is too short
    # Check DB directly to ensure no user created
    conn = get_connection(flask_app)
    cur = conn.cursor()
    cur.execute('SELECT COUNT(*) FROM users WHERE username = ?', ('testuser',))
    count = cur.fetchone()[0]
    conn.close()
    assert count == 0


def test_database_path_mismatch(client):
    # README claims DB is at data/database.sqlite3
    assert 'data/database.sqlite3' != flask_app.config.get('DATABASE')
