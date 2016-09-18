Sequel.migration do
  up do
    create_table(:messages) do
      primary_key :id

      DateTime :timestamp

      Integer :server_id, null: false
      String :server_name, null: false

      Integer :channel_id, null: false
      String :channel_name, null: false

      Integer :user_id, null: false
      String :user_name, null: false

      Integer :message_id, null: false
      String :message_content
      String :attachment_url
    end
  end

  down do
    drop_table(:messages)
  end
end
