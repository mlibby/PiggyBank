Sequel.migration do
  change do
    create_table(:api_key) do
      primary_key :api_key_id
      String :description, text: true, null: false
      String :value, text: true, null: false
      String :version, text: true, null: false
      
      index [:description], name: :api_key_uniq, unique: true
    end
    
    create_table(:commodity) do
      primary_key :commodity_id
      Integer :type, null: false
      String :name, text: true, null: false
      String :description, text: true, null: false
      String :ticker, text: true
      Integer :fraction, null: false
      String :version, text: true, null: false
      
      index [:type, :name], name: :commodity_uniq, unique: true
    end

    create_table(:tx) do
      primary_key :tx_id
      String :post_date, text: true, null: false
      String :number, text: true
      String :description, text: true, null: false
      String :version, text: true, null: false
    end
    
    create_table(:account) do
      primary_key :account_id
      foreign_key :parent_id, :account, key: [:account_id]
      foreign_key :commodity_id, :commodity, null: false, key: [:id]
      String :name, text: true, null: false
      TrueClass :is_placeholder, default: false, null: false
      Integer :type, null: false
      String :typeData, text: true
      String :version, text: true, null: false
      
      index [:name, :parent_id], name: :account_uniq, unique: true
    end
    
    create_table(:price) do
      primary_key :price_id
      foreign_key :currency_id, :commodity, null: false, key: [:commodity_id]
      foreign_key :commodity_id, :commodity, null: false, key: [:commodity_id]
      String :quote_date, text: true, null: false
      BigDecimal :value, null: false
      String :version, text: true, null: false
      
      index [:currency_id, :commodity_id, :quote_date], name: :price_uniq
    end
    
    create_table(:ofx) do
      primary_key :ofx_id
      TrueClass :active, default: false, null: false
      foreign_key :account_id, :account, null: false, key: [:account_id]
      String :url, default: "", text: true, null: false
      String :user, default: "", text: true, null: false
      String :password, default: "", text: true, null: false
      Integer :fid, null: false
      String :fid_org, text: true, null: false
      String :bank_id, default: "", text: true, null: false
      String :bank_account_id, text: true, null: false
      String :account_type, text: true, null: false
      String :version, text: true, null: false
    end
    
    create_table(:split) do
      primary_key :split_id
      foreign_key :tx_id, :tx, null: false, key: [:tx_id]
      foreign_key :account_id, :account, null: false, key: [:account_id]
      foreign_key :commodity_id, :commodity, null: false, key: [:commodity_id]
      String :memo, text: true
      BigDecimal :amount, null: false
      BigDecimal :value, null: false
      String :version, text: true, null: false
    end
    
    create_table(:ofx_import) do
      primary_key :ofx_import_id
      foreign_key :ofx_id, :ofx, null: false, key: [:ofx_id]
      String :downloaded, text: true, null: false
      String :start_date, text: true, null: false
      String :end_date, text: true, null: false
      Integer :tx_count, null: false
      Integer :tx_loaded, null: false
      BigDecimal :balance
      String :balance_date, text: true
      String :version, text: true, null: false
    end
  end
end
