from decimal import Decimal
import flask.json

class PiggyBankJSONEncoder(flask.json.JSONEncoder):
    def default(self, obj):
        retval = ''
        if isinstance(obj, Decimal):
            retval = "%.02f" % obj
        else:
            retval = super(PiggyBankJSONEncoder, self).default(obj)
        return retval

    
