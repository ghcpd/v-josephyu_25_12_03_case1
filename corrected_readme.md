# Flask User Management Tutorial (Corrected)

This repository implements a simple Flask user management example (registration, login, profile view) with SQLite.

Quick facts (corrected):
- App endpoints: `/register`, `/login`, `/logout`, `/dashboard` (protected)
- Default database file: `app.db` (config: `app.config['DATABASE']`)
- Password minimum length enforced by forms: 6 characters (see `auth.py`)
- Sessions: default Flask sessions (signed cookies). Redis is not used.
- Secret / CSRF: set `SECRET_KEY` in environment or in config.

## Setup (.venv)

Windows (PowerShell):

```powershell
python -m venv .venv
& .venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Linux/macOS (bash):

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run the app

Start the server:

```bash
python app.py
```

Then open `http://localhost:5000` and register/login using `/register` and `/login`.

## Notes for developers

- If you want to use a different DB path, set `app.config['DATABASE'] = 'data/database.sqlite3'` or set it via environment when constructing the app.
- If you want to change the minimum password length, alter the `Length(min=6)` validator in `auth.py`.
- The README originally referenced endpoints `/signup` and `/signin`, `FLASK_SECRET` env var, Redis sessions, and `/api/*` endpoints; these are not present in the code and have been corrected here.

## Tests

Run tests with pytest:

```bash
pytest -q
```

Tests included: `tests/test_readme_examples.py` which reproduces the issues documented in the original (defective) README and validates behavior.
