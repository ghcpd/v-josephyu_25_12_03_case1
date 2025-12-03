from flask import url_for

from models import get_connection, User


def register(client, username, email, password, follow_redirects=False):
    return client.post(
        "/register",
        data={"username": username, "email": email, "password": password},
        follow_redirects=follow_redirects,
    )


def login(client, username, password, follow_redirects=False):
    return client.post(
        "/login",
        data={"username": username, "password": password},
        follow_redirects=follow_redirects,
    )


def test_register_and_login_flow(client, app):
    # Register
    resp = register(client, "alice", "alice@example.com", "password123")
    assert resp.status_code == 302
    assert resp.headers["Location"].endswith("/dashboard")

    # Logout
    resp = client.get("/logout")
    assert resp.status_code == 302
    assert resp.headers["Location"].endswith("/login")

    # Login
    resp = login(client, "alice", "password123")
    assert resp.status_code == 302
    assert resp.headers["Location"].endswith("/dashboard")

    # Verify dashboard content when authenticated
    resp = client.get("/dashboard", follow_redirects=True)
    assert b"Hello, <strong>alice</strong>" in resp.data


def test_login_invalid_password(client, app):
    register(client, "bob", "bob@example.com", "secret123")
    # Use a password that passes length validation but is incorrect
    resp = login(client, "bob", "wrongpass", follow_redirects=True)
    assert resp.status_code == 200
    assert b"Invalid username or password" in resp.data


def test_unique_username_and_email(client, app):
    register(client, "charlie", "charlie@example.com", "secret123")

    # Duplicate username
    resp = register(client, "charlie", "new@example.com", "secret123", follow_redirects=True)
    assert resp.status_code == 200
    assert b"Username is already taken" in resp.data

    # Duplicate email with a different username
    resp = register(client, "charlie2", "charlie@example.com", "secret123", follow_redirects=True)
    assert resp.status_code == 200
    assert b"Email is already registered" in resp.data


def test_dashboard_requires_login(client, app):
    resp = client.get("/dashboard")
    assert resp.status_code == 302
    assert "/login" in resp.headers["Location"]


def test_logout_requires_login_redirects(client, app):
    # Without login, logout should redirect to login (Flask-Login default behavior)
    resp = client.get("/logout")
    assert resp.status_code == 302
    assert "/login" in resp.headers["Location"]


def test_password_hashing(client, app):
    register(client, "dana", "dana@example.com", "supersecret")
    conn = get_connection(app)
    user = User.get_by_username(conn, "dana")
    conn.close()
    assert user is not None
    assert user.password_hash != "supersecret"
    assert user.verify_password("supersecret")
