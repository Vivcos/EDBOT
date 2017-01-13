Sequel.migration do
  up do
    create_table(:metadata) do
      primary_key :snowflake
      String :data
    end
  end

  down do
    drop_table :metadata
  end
end
