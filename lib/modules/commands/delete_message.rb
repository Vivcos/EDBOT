module Powerbot
  module DiscordCommands
    # Deletes a message.
    module DeleteMessage
      extend Discordrb::Commands::CommandContainer
      command(:delete_message,
              required_permissions: [:manage_messages],
              min_args: 1,
              description: 'Deletes a message. Must be a moderator to use.',
              usage: "#{BOT.prefix}delete_message message_id reason"
      ) do |event, id, *reason|
        reason = reason.join(' ')
        message = Database::Message.find(message_id: id)
        unless message.nil?
          log = Database::ModLog.create(server_id: event.server.id,
                                        action: 'Message Removal',
                                        message: message,
                                        reason: reason,
                                        moderator_id: event.user.id,
                                        offender_id: message.user_id)
          log.post
          event.message.delete
          message.message.delete
          return
        end
        'I couldn\'t find that message..'
      end
    end
  end
end
