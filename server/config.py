import os
from dotenv import load_dotenv

basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(basedir, ".env"))

db_url = os.environ.get("DATABASE_URL")
if db_url is not None and db_url.startswith("postgres://"):
    db_url = db_url.replace("postgres://", "postgresql://", 1)
    os.environ["DATABASE_URL"] = db_url


class Config(object):
    SQLALCHEMY_DATABASE_URI = (
        os.environ.get("DATABASE_URL")
        or f"sqlite:///{ os.path.join(basedir, 'PiggyBank.sqlite') }"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
