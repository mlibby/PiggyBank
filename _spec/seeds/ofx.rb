def seed_ofx
  assets = PiggyBank::Account.find(name: "Assets")
  PiggyBank::Ofx.create active: true,
                        account_id: assets.account_id,
                        url: "foz.baz.com",
                        user: "user ofx",
                        password: "pass ofx",
                        fid: "98765",
                        fid_org: "C2",
                        bank_id: "y",
                        bank_account_id: "#####",
                        account_type: "SAVINGS"
end
