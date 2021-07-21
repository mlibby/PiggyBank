import unittest
from server.models import Commodity, CommodityType
#from server.tests import test_db, finalize
#from server.tests.models.reset_db import reset_db


# class TestCommodity(unittest.TestCase):
#     def setUp(self):
#         self.app_context, self.db = test_db()

#     def tearDown(self):
#         finalize(self.app_context, self.db)

#     def test_commodity_get(self):
#         usd = Commodity.query.filter_by(name="USD").first()
#         assert usd is not None
#         assert usd.commodity_type == CommodityType.CURRENCY
#         assert usd.__repr__() == f"<Commodity {usd.id}:'USD'>"

#     def test_commodity_dict(self):
#         usd = Commodity.query.filter_by(name="USD").first()
#         dusd = dict(usd)
#         assert "id" in dusd
#         assert "commodity_type" in dusd
#         assert "name" in dusd
#         assert "description" in dusd
#         assert "ticker" in dusd
