Sequel.migration do
  up do
    create_table(:feeds) do
      primary_key :id
      Integer :server_id, null: false
      Integer :role_id, unique: true, null: false
      Integer :channel_id, null: false
      String :name, null: false
    end
  end

  down do
    drop_table(:feeds)
  end
end
