module Powerbot
  module DiscordCommands
    # Bans a user.
    module DeleteMessage
      extend Discordrb::Commands::CommandContainer
      command(:ban,
              required_permissions: [:kick_members],
              min_args: 1,
              description: 'Bans a user. Must be a moderator to use.',
              usage: "#{BOT.prefix}ban @user reason"
      ) do |event, user, *reason|
        reason = reason.join(' ')
        user = event.message.mentions.first
        unless user.nil?
          user = user.on(event.server)
          log = Database::ModLog.create(server_id: event.server.id,
                                        action: 'User Ban',
                                        reason: reason,
                                        moderator_id: event.user.id,
                                        offender_id: user.id)
          log.post
          event.message.delete
          event.server.ban(user)
          return
        end
        'I couldn\'t find that user..'
      end
    end
  end
end
