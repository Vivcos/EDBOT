Sequel.migration do
  up do
    create_table(:star_messages) do
      primary_key :id
      Integer :starred_channel_id
      Integer :starred_message_id, unique: true, null: false
      Integer :channel_id
      Integer :message_id, unique: true
    end

    create_table(:stars) do
      primary_key :id
      Integer :user_id, null: false
      foreign_key :star_message_id, on_delete: :cascade
    end
  end

  down do
    drop_table(:star_messages)
    drop_table(:stars)
  end
end
