Sequel.migration do
  up do
    create_table(:metadatas) do
      primary_key :snowflake
      String :data
    end
  end

  down do
    drop_table :metadatas
  end
end
