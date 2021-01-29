Sequel.migration do
  change do
    alter_table(:split) do
      drop_column :commodity_id
    end
  end
end