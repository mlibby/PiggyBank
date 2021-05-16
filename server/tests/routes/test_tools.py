import pytest
from server.tests import client


def test_tools_amortization(client):
    input = {
        'principal': '225000',
        'rate': '4.25',
        'number': '360',
        'periods': '12',
        'extra_amount': '0',
        'extra_lumps': {}
    }
    page = client.post('/api/tools/amortization', json=input)
    data = page.data.decode()
    assert 'payments' in data
