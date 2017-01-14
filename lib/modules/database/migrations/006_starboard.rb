Sequel.migration do
  up do
    create_table(:star_messages) do
      primary_key :id
      Integer :channel_id, null: false
      Integer :message_id, unique: true, null: false
    end

    create_table(:stars) do
      primary_key :id
      Integer :user_id, null: false
      foreign_key :star_message_id, :star_messages, on_delete: :cascade
    end
  end

  down do
    drop_table(:star_messages)
    drop_table(:stars)
  end
end
