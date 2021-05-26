from decimal import Decimal
import flask.json


class PiggyBankJSONEncoder(flask.json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return "%.02f" % obj
        else:
            return super().default(obj)
