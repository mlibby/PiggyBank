import os
from dotenv import load_dotenv

basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(basedir, ".env"))


class Config(object):
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = os.environ.get("SECRET_KEY")
    SESSION_COOKIE_SAMESITE = "Strict"


class DevelopmentConfig(Config):
    db_path = os.path.join(basedir, "PiggyBank.sqlite")
    SQLALCHEMY_DATABASE_URI = f"sqlite:///{ db_path }"


class TestConfig(Config):
    SQLALCHEMY_DATABASE_URI = "sqlite://"


class DemoConfig(TestConfig):
    db_url = os.environ.get("DATABASE_URL")
    if db_url is not None:
        SQLALCHEMY_DATABASE_URI = db_url.replace("postgres://", "postgresql://", 1)


config = {
    "default": Config,
    "development": DevelopmentConfig,
    "production": Config,
    "testing": TestConfig,
    "demo": DemoConfig,
}
