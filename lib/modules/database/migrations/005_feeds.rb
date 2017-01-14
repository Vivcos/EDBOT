Sequel.migration do
  up do
    create_table(:feeds) do
      primary_key :id
      Integer :channel_id, null: false
      Integer :role_id, unique: true, null: false
    end
  end

  down do
    drop_table(:feeds)
  end
end
