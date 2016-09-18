module Powerbot
  module DiscordCommands
    # Kicks a user.
    module DeleteMessage
      extend Discordrb::Commands::CommandContainer
      command(:kick,
              required_permissions: [:kick_members],
              min_args: 1,
              description: 'Kicks a user. Must be a moderator to use.',
              usage: "#{BOT.prefix}kick @user reason"
      ) do |event, user, *reason|
        reason = reason.join(' ')
        user = event.message.mentions.first
        unless user.nil?
          user = user.on(event.server)
          log = Database::ModLog.create(server_id: event.server.id,
                                        action: 'User Kick',
                                        reason: reason,
                                        moderator_id: event.user.id,
                                        offender_id: user.id)
          log.post
          event.message.delete
          event.server.kick(user)
          return
        end
        'I couldn\'t find that user..'
      end
    end
  end
end
