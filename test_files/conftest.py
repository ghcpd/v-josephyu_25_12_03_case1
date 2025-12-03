import os
import tempfile
import pytest

from app import app as flask_app
from models import init_db


@pytest.fixture
def app():
    db_fd, db_path = tempfile.mkstemp(prefix="test_app_", suffix=".db")
    os.close(db_fd)
    flask_app.config.update(
        TESTING=True,
        WTF_CSRF_ENABLED=False,
        DATABASE=db_path,
        SECRET_KEY="test-secret-key",
    )
    init_db(flask_app)
    yield flask_app
    try:
        os.remove(db_path)
    except OSError:
        pass


@pytest.fixture
def client(app):
    return app.test_client()
