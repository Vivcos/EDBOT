Sequel.migration do
  up do
    create_table(:mod_logs) do
      primary_key :id
      DateTime :timestamp, null: false
      Integer :server_id, null: false
      String :action, null: false
      foreign_key :message_id, :messages, on_delete: :set_null
      String :reason, default: 'none provided'
      String :moderator_id
      String :offender_id
    end
  end

  down do
    drop_table(:mod_logs)
  end
end
