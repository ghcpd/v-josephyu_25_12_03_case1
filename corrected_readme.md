# Flask User Management - Working README

This app provides a minimal Flask login/registration flow using Flask-Login, Flask-WTF, and SQLite.

## Prerequisites
- Python 3.8+
- (Recommended) `python -m venv .venv`

## Setup

### Bash
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### PowerShell
```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## Quick Start
```bash
python app.py
```

The app runs on `http://127.0.0.1:5000` (default). Host/port CLI flags are **not** supported.

## Routes
- `GET /register` – Registration form (fields: **username**, **email**, **password**; password min length **6**)
- `POST /register` – Creates user if username and email are unique; logs user in on success
- `GET /login` – Login form (fields: **username**, **password**)
- `POST /login` – Authenticates user and redirects to dashboard
- `GET /dashboard` – Protected page showing current user
- `GET /logout` – Logs out the current user

> **Note**
> - Email is **required** and must be unique.
> - Password minimum length is **6** characters.
> - Database file: `app.db` at the project root.
> - Sessions use Flask’s default secure cookie sessions (no Redis).

## Testing
```bash
pytest
```

Or use the provided scripts:
- `./run_tests.sh`
- `./run_tests.ps1`
