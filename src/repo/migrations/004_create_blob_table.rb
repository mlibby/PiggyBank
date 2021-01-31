Sequel.migration do
  change do
    create_table(:blob) do
      primary_key :blob_id
      String :name, text: true, null: false
      String :yaml, text: true, null: false

      index [:name], name: :blob_uniq, unique: true
    end
  end
end
