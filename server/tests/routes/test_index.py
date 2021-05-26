import pytest
from server.tests import client


def test_default_page(client):
    page = client.get("/")
    html = page.data.decode()

    assert "<html" in html


def test_favicon(client):
    page = client.get("/favicon.ico")
    assert page.status == "200 OK"
