def reset_db(db):
    db.drop_all()
    db.create_all()

    add_commodities(db)
    add_accounts(db)


def add_accounts(db):
    from server.models import Account, AccountType, Commodity
    usd = Commodity.query.filter_by(name="USD").first()
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
            commodity_id=usd.id,
        )
        db.session.add(account)
    db.session.commit()

    equity = Account.query.filter_by(name="Equity").first()
    open_bal = Account(
        name="Opening Balance",
        account_type=AccountType.EQUITY,
        is_placeholder=False,
        commodity_id=usd.id,
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
