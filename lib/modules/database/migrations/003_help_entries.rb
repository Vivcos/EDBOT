Sequel.migration do
  up do
    create_table(:help_entries) do
      primary_key :id
      DateTime :timestamp
      String :author
      String :key
      String :text
      TrueClass :channel_specific, default: true
      Integer :channel_id
    end
  end

  down do
    drop_table(:help_entries)
  end
end
