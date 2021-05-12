import pytest
from server.tests import client

def test_default_page(client):
    page = client.get('/')
    html = page.data.decode()

    assert "<html" in html
