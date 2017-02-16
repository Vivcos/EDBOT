Sequel.migration do
  up do
    add_column :star_messages, :author_id, Integer
  end

  down do
    drop_column :star_messages, :author_id
  end
end
