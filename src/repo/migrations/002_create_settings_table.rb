Sequel.migration do
  change do
    create_table(:setting) do
      primary_key :setting_id
      String :name, text: true, null: false
      String :value, text: true, null: false
      String :version, text: true, null: false

      index [:name], name: :setting_uniq, unique: true
    end
  end
end
