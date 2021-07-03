from server.models import (
    Account,
    AccountType,
    commodity,
    Commodity,
)


def reset_db(db):
    db.drop_all()
    db.create_all()

    usd_id = add_commodities(db)
    add_accounts(db, usd_id)
    # add_user(db)


def add_accounts(db, usd_id):
    add_base_accounts(db, usd_id)
    add_equity_subaccounts(db, usd_id)


def add_base_accounts(db, usd_id):
    base_accounts = [
        ("Assets", AccountType.ASSET),
        ("Liabilities", AccountType.LIABILITY),
        ("Equity", AccountType.EQUITY),
        ("Income", AccountType.INCOME),
        ("Expense", AccountType.EXPENSE),
    ]
    for (name, account_type) in base_accounts:
        account = Account(
            name=name,
            account_type=account_type,
            is_placeholder=True,
            commodity_id=usd_id,
        )
        db.session.add(account)
    db.session.commit()


def add_equity_subaccounts(db, usd_id):
    equity = Account.query.filter_by(name="Equity").first()
    open_bal = Account(
        name="Opening Balance",
        account_type=AccountType.EQUITY,
        is_placeholder=False,
        commodity_id=usd_id,
        parent_id=equity.id,
    )
    db.session.add(open_bal)
    db.session.commit()


def add_commodities(db):
    from server.models import Commodity, CommodityType

    usd = Commodity(
        commodity_type=CommodityType.CURRENCY,
        description="US Dollar",
        fraction=100,
        name="USD",
        ticker="USD",
    )
    db.session.add(usd)
    db.session.commit()

    return usd.id


def add_user(db):
    from server.models import User

    u = User(username="foobar")
    u.set_password("foobar")

    db.session.add(u)
    db.session.commit()
