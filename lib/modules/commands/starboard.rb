module Powerbot
  module DiscordCommands
    # Commands for managing a server's Starboard
    module Starboard
      extend Discordrb::Commands::CommandContainer

      # Link the starboard channel
      command(:'starboard.link', permission_level: 3, help_available: false) do |event, channel_id|
        server_options = Database::Metadata[event.server.id]
        server_options ||= Database::Metadata.from_hash event.server.id, {}

        server_options.merge({ star_channel_id: channel_id.to_i })

        '🆗'
      end

      # Toggles allowing messages to be starred in the channel its run in
      command(:'allow_stars', permission_level: 3, help_available: false) do |event|
        channel_options = Database::Metadata[event.channel.id]
        channel_options ||= Database::Metadata.from_hash event.channel.id, {}

        current_option = channel_options.read['allow_stars']

        channel_options.merge({ allow_stars: !current_option })

        '🆗'
      end

      command(:who_starred, help_available: false) do |event, id|
        maybe_star = Database::StarMessage.find starred_message_id: id.to_i

        next 'Message not found or not starred..' unless maybe_star

        users = maybe_star.stars.map do |s|
          BOT.users[s.user_id]
        end.compact

        users.map(&:name).join ', '
      end

      command(:star,
              description: 'adds a star to a starred message by ID',
              usage: "#{BOT.prefix}.star <message ID>") do |event, id|
        maybe_star = Database::StarMessage.find starred_message_id: id.to_i

        next 'Message not found or not starred..' unless maybe_star
        next 'You can only star a message once.' if maybe_star.starred_by? event.user.id

        maybe_star.add_star user_id: event.user.id

        DiscordEvents::Star.update_star maybe_star

        event.message.delete
      end
    end
  end
end
