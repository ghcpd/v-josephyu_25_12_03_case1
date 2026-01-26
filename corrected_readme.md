# Flask User Management — Corrected README

This project is a minimal Flask user registration/login example. The original README had mismatches; this document reflects the actual implementation and working commands.

Prerequisites
- Python 3.10+ (3.11 recommended)
- Git (optional)

Quick setup (Windows PowerShell)

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Quick setup (POSIX / bash)

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

Run the app (development)

```powershell
# Run using the venv's python
.venv\Scripts\python app.py
# The app listens on 127.0.0.1:5000 by default (development)
```

Working routes

- GET / -> redirects to login when not authenticated
- GET/POST /login -> login form (fields: username, password)
- GET/POST /register -> register form (fields: username, email, password)
- GET /logout -> log out
- GET /dashboard -> main page (requires login)

Notes about differences vs original README
- The register route is `/register` (not `/signup`) and login is `/login` (not `/signin`).
- There's no `/profile` route; the protected page is `/dashboard`.
- There are no JSON API endpoints `/api/register` or `/api/login` (they return 404).
- The register form requires an `email` field; it is not optional.
- Password minimum length is 6 characters (see `RegisterForm` in `auth.py`).
- The code sets the SQLite database file to `app.db` by default.
- The app configuration uses `app.config['SECRET_KEY']` (not `FLASK_SECRET` env variable). You may set `SECRET_KEY` via environment or other config if desired.

Testing

Run the project's tests after setting up the venv

```bash
./run_tests.sh
# or on Windows PowerShell
.\run_tests.ps1
```

If you need to change database path or other settings for tests or development, set `app.config['DATABASE']` in code or use a custom wrapper.
