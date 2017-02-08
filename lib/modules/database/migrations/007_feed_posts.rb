Sequel.migration do
  up do
    create_table(:feed_posts) do
      primary_key :id
      foreign_key :feed_id, :feeds, on_delete: :cascade
      Integer :author_id
      Integer :message_id
      String :title
      String :content, length: 2000
    end
  end

  down do
    drop_table(:feed_posts)
  end
end
