Sequel.migration do
  up do
    create_table(:feed_posts) do
      primary_key :id
      Integer :message_id
    end
  end

  down do
    drop_table(:feed_posts)
  end
end
