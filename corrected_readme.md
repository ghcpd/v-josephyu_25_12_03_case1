# Flask User Management – Corrected README

This repo contains a minimal Flask app with username/password authentication using Flask-Login and WTForms. This guide reflects the **actual implementation** and provides working setup, run, and test commands.

---
## 1) Prerequisites
- Python 3.10+ (tested with 3.13)
- Git (optional)
- On Windows, use PowerShell; on macOS/Linux, use Bash

---
## 2) Setup (.venv)
### Bash
```bash
./setup.sh
# or manually
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

### PowerShell
```powershell
./setup.ps1
# or manually
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

> After setup, activate the virtual environment in each new shell (`source .venv/bin/activate` or `.\.venv\Scripts\Activate.ps1`).

---
## 3) Run the app
### Simple (default host/port)
```bash
python app.py
```
- Serves on **http://127.0.0.1:5000**
- Debug mode is enabled by default in `app.py`

### Custom host/port (via `flask run`)
```bash
# Bash
export FLASK_APP=app.py
flask run --host=0.0.0.0 --port=8080

# PowerShell
$env:FLASK_APP = "app.py"
flask run --host=0.0.0.0 --port=8080
```

> The `python app.py --host ... --port ...` CLI flags are **not parsed** by the app. Use `flask run` for custom host/port.

---
## 4) Routes & Behavior
| Path        | Method | Description                                      |
|-------------|--------|--------------------------------------------------|
| `/`         | GET    | Redirects to `/dashboard` if logged in, else `/login` |
| `/register` | GET/POST | Register with `username`, `email`, `password` (email required; password min length **6**) |
| `/login`    | GET/POST | Login with `username`, `password` (min length **6**) |
| `/dashboard`| GET    | Authenticated landing page                       |
| `/logout`   | GET    | Logs out and redirects to `/login`               |

**Validation & constraints**
- `username`: unique, 3–32 chars
- `email`: unique, required, validated format
- `password`: minimum 6 characters
- No `confirm_password` field is implemented

**CSRF**
- Flask-WTF CSRF is enabled; for tests we disable it (see `test_files/conftest.py`).
- `SECRET_KEY` is defined in `app.py` (`replace-with-a-strong-secret-key`). Update this value for production.

**Database**
- SQLite file at `app.db` (repo root)
- Tables auto-created on startup by `init_db(app)`
- To reset, delete `app.db` and rerun the app

---
## 5) Testing
Run the provided pytest suite:

### Bash
```bash
./run_tests.sh
```

### PowerShell
```powershell
./run_tests.ps1
```

Direct command:
```bash
python -m pytest -q test_files
```

---
## 6) Notes / Production Hardening
- Replace `SECRET_KEY` with a strong secret (e.g., from env var) before deploying.
- Debug mode is for development only.
- Sessions use signed cookies (no Redis backend is configured).
- Add HTTPS, rate limiting, and password policies as needed.

---
## 7) Changelog
- Corrected routes and field requirements to match code.
- Documented accurate database path and session storage.
- Added setup and test runner scripts.
- Provided working host/port instructions via `flask run`.
